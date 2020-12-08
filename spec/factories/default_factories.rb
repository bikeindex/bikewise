FactoryBot.define do
  factory :bike do
  end
  factory :bw_report do
  end
  factory :country do
  end
  factory :crash do
  end
  factory :hazard do
  end
  factory :image do
  end
  factory :import_status do
  end
  factory :incident_report do
  end
  factory :incident do
  end
  factory :legacy_bw_report do
  end
  factory :scf_report do
  end
  factory :selection do
  end
  factory :theft do
  end
  factory :user do
  end
  factory :incident_type_theft, class: IncidentType do 
    name { 'Theft' }
  end
end