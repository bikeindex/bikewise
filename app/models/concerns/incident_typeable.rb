module IncidentTypeable
  extend ActiveSupport::Concern

  included do
    has_one :incident, as: :type_properties
    has_one :incident_type, through: :incident
  end

end