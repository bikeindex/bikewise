class SaverWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'tasker', backtrace: true
    
  def perform(id)
    incident = Incident.find(id)
    incident.feature_marker = incident.simplestyled_geojson
    incident.save
  end
end
