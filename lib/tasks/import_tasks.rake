desc "import from SeeClickFix"
task :seeclickfix_import => :environment do
  import = ImportStatus.find_or_create_by(source: "seeclickfix")
  import.info_hash[:imported_pages] = [] unless import.info_hash[:imported_pages].present?
  last_page = 3
  integration = SeeClickFixIntegration.new
  last_page_issues = integration.get_issues_page(last_page)
  last_updated_at = integration.last_issue_updated_at(last_page_issues)
  last_page = 8 unless last_updated_at > (Time.now - 2.hours)
  integration.make_reports_from_issues_page(last_page_issues)
  # puts "\nProcessing pages up to page #{last_page}"
  pages = (1...(last_page)).to_a
  pages.each do |page|
    next if import.info_hash[:imported_pages].include?(page)
    import.info_hash[:imported_pages] << page
    GetScfReportsWorker.perform_async(page)
  end
  import.info_hash[:imported_pages].uniq!
  import.save
end

desc "import from BikeIndex"
task :bikeindex_import => :environment do
  import = ImportStatus.find_or_create_by(source: "bikeindex")
  integration = BikeIndexIntegration.new
  time = (import.updated_at || Time.now) - 1.hours
  bike_ids = integration.get_stolen_bikes_updated_since(time)
  bike_ids.each { |id| GetBinxReportWorker.perform_async(id) }
  import.info_hash[:stolen_bikes_to_import] = bike_ids
  import.save
end

desc "Process unprocessed reports"
task :process_reports => :environment do
  report_klasses = ["BinxReport", "ScfReport", "BwReport"]
  report_klasses.each do |klass|
    report_ids = klass.constantize.unprocessed.pluck(:id)
    # ScfReports take a long time to process. So don't enqueue too many all at once
    report_ids = report_ids.shuffle.slice(0..50) if klass == "ScfReport"
    report_ids.each { |id| ProcessReportsWorker.perform_async(klass, id) }
  end
end

desc "Process unprocessed reports"
task :process_existing_reports => :environment do
  IncidentReport.find_each do |ir|
    ProcessReportsWorker.perform_async(ir.report_type, ir.report_id)
  end
end

desc "import from Bikewise data dump"
task :bikewise_import => :environment do
  files = ["crash", "hazard"]
  files.each do |source|
    og_path = File.join(Rails.root, "/bikewise_data/#{source}csv")
    line_number = 0
    CSV.foreach(og_path, { headers: true, col_sep: "\t" }) do |row|
      line_number += 1
      # puts row.to_hash
      report = LegacyBwReport.find_or_new_from_external_api(row.to_hash)
      raise StandardError, "No report for #{line_number}" unless report.save
      report.reload.create_or_update_incident
      puts "#{report.external_api_id} -> #{report.incident.id}:  #{report.incident.title}"
    end
  end
end

task :bikewise_photo_import => :environment do
  files = ["crash", "hazard"]
  files.each do |source|
    og_path = File.join(Rails.root, "/bikewise_data/#{source}_photos.csv")
    line_number = 0
    CSV.foreach(og_path, { headers: true, col_sep: "\t" }) do |row|
      line_number += 1
      r = row.to_hash
      report = LegacyBwReport.find_by(external_api_id: "#{source}#{r[source]}")
      i = report.incident.id
      puts "Incident: #{i} -> #{r["file"]}"
      url = "http://www.bikewise.org/static/uploads/#{r["file"]}"
      Image.create(incident_id: i, remote_image_url: url) unless Image.where(incident_id: i).present?
    end
  end
end

desc "import users Bikewise data dump"
task :bikewise_user_import => :environment do
  source = "user.csv"
  og_path = File.join(Rails.root, "/bikewise_data/#{source}")
  line_number = 0
  CSV.foreach(og_path, { headers: true, col_sep: "\t" }) do |row|
    line_number += 1
    h = row.to_hash
    # puts h
    next if h["email"].present? && h["email"].strip.match(/(to DELETE)|(deleted?\z)/i)
    user = User.find_or_new_from_legacy_hash(h)
    raise StandardError, "User error for #{line_number} - #{user.errors.messages}" unless user.save
    puts "#{user.legacy_bw_id}:  is now #{user.id}"
  end
end
