module API
  module V2
    class Locations < API::V2::Root
      include API::V2::Defaults

      resource :locations do
        # desc "Return paginated incidents matching passed parameters"
        # get do
        #   incidents = find_incidents
        #   incidents = incidents.limit(100) unless params[:all]
        #   geoj = { type: "FeatureCollection", features: incidents.as_geojson }
        #   render geoj
        # end
      end
    end
  end
end