module API
  module V2
    class Locations < API::V2::Root
      include API::V2::Defaults

      resource :locations do
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
          use :find_incident_params
          optional :all, type: Boolean, desc: "Give 'em all to me"
        end
        get '/' do
          incidents = find_incidents
          incidents = incidents.limit(100) unless params[:all]
          geoj = { type: "FeatureCollection", features: incidents.as_geojson }
          render geoj
        end

      end
    end
  end
end