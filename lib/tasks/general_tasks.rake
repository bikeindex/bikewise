desc "Start the server locally"
task :start do
  system 'redis-server &'
  system 'bundle exec foreman start -f Procfile_development'
end

desc "Create redis array of mapbox_geojson"
task :build_mapbox_geojson => :environment do  
  Redis.current.expire(ENV['MAPBOX_LIST_ID'], 0)
  Incident.where(incident_type_id: IncidentType.fuzzy_find_id('theft')).
    pluck(:id).each { |i| ExportMapboxWorker.perform_async(i) }
end

task :write_mapbox_geojson => :environment do 
  path = ENV['MAPBOX_EXPORT_TARGET'] + '/mapbox_geojson.geojson'
  output = File.open(path, "w")
  output.write '{"type": "FeatureCollection","features": ['
  Redis.current.lrange(ENV['MAPBOX_LIST_ID'], 0, -2).each { |i| output.write i + "," }
  Redis.current.lrange(ENV['MAPBOX_LIST_ID'], -1, -1).each { |i| output.write i }
  output.write ']}'
  output.close
end