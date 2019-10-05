module API
  module V1
    module IncidentFinder
      extend ActiveSupport::Concern
      included do
        helpers do
          def find_incidents
            incidents = Incident.all
            if params[:updated_since].present?
              if params[:occurred_since] == "yesterday"
                date = (Time.now - 1.days)
              else
                date = Time.at(params[:updated_since].to_i).utc.to_datetime
              end
              incidents = incidents.where("updated_at >= ?", date)
            end
            if params[:email].present?
              user = User.where(email: params[:email]).first
              incidents = user.incidents if user.present?
            end
            if params[:occurred_since].present?
              date = Time.at(params[:occurred_since].to_i).utc.to_datetime
              incidents = incidents.where("occurred_at >= ?", date)
            end
            if params[:occurred_before].present?
              date = Time.at(params[:occurred_before].to_i).utc.to_datetime
              incidents = incidents.where("occurred_at <= ?", date)
            end
            if params[:incident_types].present?
              incident_types = params[:incident_types]
              incident_types = incident_types.split(",") unless incident_types.kind_of?(Array)
              ids = incident_types.map { |k| IncidentType.fuzzy_find_id(k) }
              incidents = incidents.where("incident_type_id IN (?)", ids)
            end
            if params[:location].present?
              width = params[:location_width].present? ? params[:location_width] : 50
              box = Geocoder::Calculations.bounding_box(params[:location], width)
              # If the proximity is an invalid location, some of the box coordinates will be NotANumber
              # just return no incidents
              if box.any? { |l| l.nan? }
                incidents = incidents.where(id: nil) # hack to make it no locations
              else
                incidents = incidents.with_location.within_bounding_box(box)
              end
            end
            if params[:query].present?
              incidents = incidents.search_text(params[:query])
            end
            incidents
          end
        end
      end
    end
  end
end
