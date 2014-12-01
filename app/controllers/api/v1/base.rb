module API
  module V1
    class Base < Grape::API
      mount API::V1::Incidents
      mount API::V1::Locations
      add_swagger_documentation api_version: 'v1',
                                hide_documentation_path: true
    end
  end
end