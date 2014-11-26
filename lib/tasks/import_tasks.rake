desc "import from SeeClickFix"
task :seeclickfix_import => :environment do
  import = ImportStatus.find_or_create_by(source: 'seeclickfix')
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
  import = ImportStatus.find_or_create_by(source: 'bikeindex')
  integration = BikeIndexIntegration.new 
  time = Time.now - 2.hours
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
    report_ids.each { |id| ProcessReportsWorker.perform_async(klass, id) }
  end
end

desc "Process unprocessed reports"
task :process_existing_reports => :environment do  
  IncidentReport.all.each do |ir|
    ProcessReportsWorker.perform_async(ir.report_type, ir.report_id)
  end
end

desc "import from Bikewise data dump"
task :bikewise_import => :environment do 
  source = "crash.csv"
  og_path = File.join(Rails.root,"/bikewise_data/#{source}")
  line_number = 0
  CSV.foreach(og_path, {headers: true, col_sep: "\t"}) do |row|
    # line_number += 1
    report = LegacyBwReport.find_or_new_from_external_api(row.to_hash)
    raise StandardError, "No report for #{line_number}" unless report.save
    report.reload.create_or_update_incident
    puts "#{report.external_api_id}:  #{report.incident.title}"
    # puts row.to_hash
    # puts r
    # raise StandardError if line_number > 100
  end

end