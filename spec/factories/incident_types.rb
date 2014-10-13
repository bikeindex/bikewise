# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incident_type_theft, class: IncidentType do 
    name 'Theft'
  end
end
