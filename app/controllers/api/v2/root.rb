module API
  module V2
    class Root < Base
      format :json
      version "v2"
      default_error_formatter :json
      content_type :json, "application/json"

      rescue_from :all do |e|
        API::Base.respond_to_error(e)
      end

      mount API::V2::Incidents
      mount API::V2::Locations

      add_swagger_documentation base_path: "/api",
                                api_version: "v2",
                                hide_format: true, # don't show .json
                                hide_documentation_path: true,
                                mount_path: "/swagger_doc",
                                markdown: GrapeSwagger::Markdown::KramdownAdapter,
                                cascade: false,
                                info: {
                                  title: "BikeWise API v2",
                                  description: "This is an API for accessing information about bicycling related incidents. You can find the source code on <a href='https://github.com/bikeindex/bikewise'>GitHub</a>.",
                                  contact: "support@bikeindex.org",
                                }
      route :any, "*path" do
        raise StandardError, "Unable to find endpoint"
      end
    end
  end
end
