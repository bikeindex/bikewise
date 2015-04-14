class ExportMapboxWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'tasker'
  sidekiq_options backtrace: true
  sidekiq_options unique: true
    
  def perform(id)
    incident = Incident.find(id)
    Redis.current.lpush(ENV['MAPBOX_LIST_ID'], incident.mapbox_geojson.to_json)
  end

end