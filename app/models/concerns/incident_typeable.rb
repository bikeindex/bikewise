module IncidentTypeable
  extend ActiveSupport::Concern

  included do
    has_one :incident_type, as: :type_property
  end

end