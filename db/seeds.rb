puts "Seeding..."
require File.expand_path('db/seeds/seed_countries', Rails.root)

puts "Incident types"
[
  'Unconfirmed',
  'Crash',
  'Hazard',
  'Theft',
  'Infrastructure issue',
  'Chop shop'
].each { |name| IncidentType.create(name: name)}
