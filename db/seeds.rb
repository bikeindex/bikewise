puts "Seeding..."
require File.expand_path('db/seeds/seed_countries', Rails.root)

puts "Incident types"
['Crash', 'Hazard', 'Theft'].each do |name|
  IncidentType.create(name: name)
end