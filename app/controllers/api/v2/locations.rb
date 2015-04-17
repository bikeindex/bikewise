module API
  module V2
    class Locations < API::V2::Root
      include API::V2::Defaults
      resource :locations, desc: "GeoJSON response for matching incidents" do

        helpers do
          params :location_params do
            use :find_incident_params
            optional :limit, type: Integer, desc: "Max number of results to return. Defaults to 100"
            optional :all, type: Boolean, desc: "Give 'em all to me. Will ignore limit"
          end
        end
        desc "Unpaginated geojson response", {
          notes: <<-NOTE
            **This endpoint behaves exactly like** `incidents`, but returns a valid geojson `FeatureCollection` that looks like this:

            ```
            {
              type: "FeatureCollection",
              features: [
                {
                  type: "Feature",
                  properties: {
                  id: 4474199,
                  type: "Theft",
                  occurred_at: 1428536937
                },
                  geometry: {
                  type: "Point",
                  coordinates: [ -122.6244177, 45.5164386 ]
                }
              }
            }
            ```

            It doesn't paginate. If you pass the `all` parameter it returns all matches (which can be big, > 4mb), otherwise it returns the 100 most recent.

            **Go forth and make maps!**
          NOTE
        }
        params do 
          use :location_params
        end
        get '/' do
          incidents = find_incidents
          limit = params[:limit] || 100
          incidents = incidents.limit(limit) unless params[:all]
          geoj = { type: "FeatureCollection", features: incidents.as_geojson }
          render geoj
        end

        desc "Unpaginated geojson response with simplestyled markers", {
          notes: <<-NOTE
            This behaves exactly like the root `locations` endpoint, but returns [simplestyled markers](https://github.com/mapbox/simplestyle-spec) ([mapbox styled markers](https://www.mapbox.com/guides/markers/#simple-style))

            **Go forth and make maps!**
          NOTE
        }
        params do 
          use :location_params
        end
        get '/markers' do
          incidents = find_incidents.feature_markered
          limit = params[:limit] || 100
          incidents = incidents.limit(limit) unless params[:all]
          geoj = { type: "FeatureCollection", features: incidents.unscoped.pluck(:feature_marker) }
          render geoj
        end

      end
    end
  end
end