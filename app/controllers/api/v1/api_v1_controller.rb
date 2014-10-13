module Api
  module V1
    class ApiV1Controller < ApplicationController
      respond_to :json

      def not_found
        message = { :'404' => "Couldn't find that shit" }
        respond_with message, status: 404
      end
      
      def find_incidents
        incidents = Incident.all
        if params[:updated_since].present?
          if params[:occurred_since] == 'yesterday'
            date = (Time.now - 1.days) 
          else
            date = Time.at(params[:updated_since].to_i).utc.to_datetime
          end
          incidents = incidents.where("updated_at >= ?", date)
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
          ids = []
          params[:incident_types].split(',').each do |it_name|
            i = IncidentType.find_by(slug: Slugifyer.slugify(it_name))
            ids << i.id if i.present?
          end
          incidents = incidents.where("incident_type_id IN (?)", ids)
        end
        if params[:location].present?
          width = params[:location_width].present? ? params[:location_width] : 50
          box = Geocoder::Calculations.bounding_box(params[:location], width)
          incidents = incidents.within_bounding_box(box)
        end
        if params[:query].present?
          incidents = incidents.search(params[:query])
        end
        @incidents = incidents
      end

      def find_incident
        @incident = Incident.find(params[:id])
      end

      def set_pagination
        page = params[:page]
        page ||= 1
        per_page = params[:per_page]
        per_page ||= 10
        @incidents = @incidents.page(page).per(per_page)
        @page_data = {
          page: @incidents.current_page,
          per_page: per_page,
          next_page: @incidents.next_page,
          prev_page: @incidents.prev_page,
          pages: @incidents.total_pages,
          total_count: @incidents.total_count
        }
      end

      def not_found
        message = { :'404' => "Couldn't find that shit" }
        respond_with message, status: 404
      end

      rescue_from Exception do |e|
        error(e)
      end

      def routing_error
        raise ActionController::RoutingError.new(params[:path])
      end

      def error(e)
        error_info = {
          :error => "internal-server-error",
          :exception => "#{e.class.name} : #{e.message}",
        }
        error_info[:trace] = e.backtrace[0,10]
        render :json => error_info.to_json, :status => 500
      end

    end
  end
end