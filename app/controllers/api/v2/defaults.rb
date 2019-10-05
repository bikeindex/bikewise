module API
  module V2
    module Defaults
      extend ActiveSupport::Concern
      included do
        formatter :json, Grape::Formatter::ActiveModelSerializers

        before do
          header["Access-Control-Allow-Origin"] = "*"
          header["Access-Control-Request-Method"] = "*"
        end

        helpers do
          params :find_incident_params do
            optional :occurred_before, type: Integer, desc: "End of period"
            optional :occurred_after, type: Integer, desc: "Start of period"
            optional :incident_type, type: String, values: INCIDENT_TYPES, desc: "Only incidents of specific type"
            optional :proximity, type: String, desc: "Center of location for proximity search", documentation: { example: "45.521728,-122.67326" }
            optional :proximity_square, type: Integer, desc: "Size of the proximity search", default: 100
            optional :query, type: String, desc: "Full text search of incidents"
          end

          def find_incidents
            if params[:query].present?
              incidents = Incident.search_text(params[:query])
            else
              incidents = Incident.all
            end
            if params[:occurred_after].present?
              date = Time.at(params[:occurred_after]).utc.to_datetime
              incidents = incidents.where("occurred_at >= ?", date)
            end
            if params[:occurred_before].present?
              date = Time.at(params[:occurred_before]).utc.to_datetime
              incidents = incidents.where("occurred_at <= ?", date)
            end
            if params[:incident_type].present?
              id = IncidentType.fuzzy_find_id(params[:incident_type])
              incidents = incidents.where(incident_type_id: id)
            end
            if params[:proximity].present?
              width = params[:proximity_square].present? ? params[:proximity_square] : 100
              box = Geocoder::Calculations.bounding_box(params[:proximity], width)
              # If the proximity is an invalid location, some of the box coordinates will be NotANumber
              # just return no incidents
              if box.any? { |l| l.nan? }
                incidents = incidents.where(id: nil) # hack to make it no locations
              else
                incidents = incidents.with_location.within_bounding_box(box)
              end
            end
            incidents
          end
        end
      end
    end
  end
end
