desc "initial import from SeeClickFix"
task :seeclickfix_import => :environment do
  import = ImportStatus.find_or_create_by(source: 'seeclickfix')
  import.info_hash[:imported_pages] = [] unless import.info_hash[:imported_pages].present? 
  last_page = 10
  # last_page_issues = integration.get_issues_page(last_page)
  # updated_at = integration.last_issue_updated_at(last_page_issues)
  # puts updated_at
  # last_page = 5 if updated_at > (Time.now - 1.hours)
  # integration.make_reports_from_issues_page(last_page_issues)
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

desc "initial import from BikeIndex"
task :bikeindex_import => :environment do
  import = ImportStatus.find_or_create_by(source: 'bikeindex')
  integration = BikeIndexIntegration.new 
  time = Time.now - 1.days
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