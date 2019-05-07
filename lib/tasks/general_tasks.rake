desc "Re-save a random chunk of things"
task resave_everything: :environment do
  Incident.order("RANDOM()").limit(3000).pluck(:id).each { |i| SaverWorker.perform_async(i) }
end