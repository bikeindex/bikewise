desc "initial import from SeeClickFix"
task :seeclickfix_import => :environment do
  import = ImportStatus.find_or_create_by(source: 'seeclickfix')
  import.info_hash[:imported_pages] = [] unless import.info_hash[:imported_pages].present? 
  first_page = 1
  import.info_hash[:imported_pages] << first_page

  puts "Importing SeeClickFix data\n\nStarting page #{first_page}"
  last_page = SeeClickFixIntegration.new.get_issues_and_make_reports(1)
  # last_page = 100 unless last_page < 50
  puts "\nProcessing pages up to page #{last_page}"
  pages = ((first_page+1)..(last_page)).to_a
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
  party_time = Time.now - 2.months
  bike_ids = integration.get_stolen_bikes_updated_since(party_time)
  bike_ids.each do |id| 
    GetBinxReportWorker.perform_async(id)
  end
  import.info_hash[:stolen_bikes_to_import] = bike_ids
  import.save
end


desc "Process unprocessed reports"
task :process_reports => :environment do
  report_klasses = ["BinxReport", "ScfReport", "BwReport"]
  report_klasses.each do |klass|
    report_ids = klass.constantize.pluck(:id)
    report_ids.each { |id| ProcessReportsWorker.perform_async(klass, id) }
  end
end