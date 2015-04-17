desc "Start the server locally"
task :start do
  system 'redis-server &'
  system 'bundle exec foreman start -f Procfile_development'
end

desc "Re-save everything"
task :seeclickfix_import => :environment do
  Incident.all.pluck(:id).each { |i| SaverWorker.perform_async(i) }
end