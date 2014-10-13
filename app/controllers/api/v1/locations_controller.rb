module Api
  module V1
    class LocationsController < ApiV1Controller
      before_filter :find_incidents, only: [:index]

      def index
        @incidents = @incidents.limit(1000) unless params[:all]
        geoj = { type: "FeatureCollection", features: @incidents.as_geojson }
        render json: geoj
      end

    end
  end
end