module API
  module V1
    class Locations < Grape::API
      include API::V1::Defaults
      namespace :locations do
        desc "Return paginated incidents matching passed parameters"
        get do
          incidents = find_incidents
          incidents = incidents.limit(100) unless params[:all]
          geoj = { type: "FeatureCollection", features: incidents.as_geojson }
          render geoj
        end
      end
    end
  end
end