desc "Re-save everything"
task :resave_everything => :environment do
  Incident.all.pluck(:id).each { |i| SaverWorker.perform_async(i) }
end