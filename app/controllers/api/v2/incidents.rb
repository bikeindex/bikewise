  module API
    module V2
      class Incidents < API::V2::Root
        include API::V2::Defaults
        
        resource :incidents do
          desc "Paginated incidents matching parameters", {
            notes: <<-NOTE

              If you'd like more detailed information about bike incidents, use this endpoint. For mapping, `locations` is probably a better bet.

              **Notes on location searching**: 
              - `proximity` accepts an ip address, an address, zipcode, city, or latitude,longitude - i.e. `70.210.133.87`, `210 NW 11th Ave, Portland, OR`, `60647`, `Chicago, IL`, and `45.521728,-122.67326` are all acceptable
              - `proximity_square` sets the length of the sides of the square to find matches inside of. The square is centered on the location specified by `proximity`. It defaults to 100.
            NOTE
          }
          paginate
          params do 
            use :find_incident_params
          end
          get '/' do
            paginate find_incidents
          end
        end
      end
    end
  end