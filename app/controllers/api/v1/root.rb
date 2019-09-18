module API
  module V1
    class Root < Grape::API
      format :json
      content_type :json, "application/json"
      rescue_from :all do |e|
        API::Base.respond_to_error(e)
      end
      mount API::V1::Incidents
      mount API::V1::Locations
      mount API::V1::Types

      add_swagger_documentation base_path: "/api",
                                api_version: "v1",
                                hide_format: true, # don't show .json
                                hide_documentation_path: true,
                                info: {
                                  title: "Bikewise API v1",
                                  description: "This is an API for accessing information about bicycling related incidents. You can find the source code on <a href='https://github.com/bikeindex/bikewise'>GitHub</a>.",
                                }
    end
  end
end
