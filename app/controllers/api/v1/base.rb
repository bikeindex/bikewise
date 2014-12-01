module API
  module V1
    class Base < Grape::API
      mount API::V1::Incidents
      mount API::V1::Locations
      mount API::V1::Types
      add_swagger_documentation api_version: 'v1',
                                hide_format: true, # don't show .json
                                hide_documentation_path: true
    end
  end
end