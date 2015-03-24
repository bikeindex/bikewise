  module API
    module V2
      class Incidents < API::V2::Root
        include API::V2::Defaults
        
        resource :incidents do
          desc "Return paginated incidents matching parameters"
          paginate
          params do 
            use :find_incident_params
          end
          get do
            paginate find_incidents
          end


          desc "Return a single incident" 
          params do
            requires :id, type: Integer, desc: 'Incident id.'
          end
          get ':id' do 
            incident = Incident.where(id: params[:id]).first
            unless manufacturer.present?
              msg = "Unable to find Incident with name or id: #{params[:id]}"
              raise ActiveRecord::RecordNotFound, msg
            end
            render incident
          end
        end
      end
    end
  end