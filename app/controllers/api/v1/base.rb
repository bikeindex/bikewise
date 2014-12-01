module API
  module V1
    class Base < Grape::API
      mount API::V1::Incidents
      mount API::V1::Locations
    end
  end
end