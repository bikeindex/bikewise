module API
  module V1
    class Incidents < API::V1::Root
      include API::V1::Defaults
      include API::V1::IncidentFinder
      resource :incidents do
        desc "Return paginated incidents matching parameters"
        paginate
        get do
          paginate find_incidents
        end


        desc "Return a single incident" 
        params do
          requires :id, type: Integer, desc: 'Incident id.'
        end
        get ':id' do 
          incident = Incident.find(params[:id])
          render incident
        end
      end
    end
  end
end