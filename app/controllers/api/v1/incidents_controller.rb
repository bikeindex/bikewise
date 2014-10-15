module Api
  module V1
    class IncidentsController < ApiV1Controller
      before_filter :find_incidents, only: [:index]
      before_filter :find_incident, only: [:show, :update]
      before_filter :set_pagination, only: [:index]

      def index
        respond_with @incidents, meta: @page_data
      end

      def show
        respond_with @incident, root: false
      end

      def create
        if params[:incident].present?
          # if params[:incident].kind_of?(Hash)
          #   puts "A HASH!?"
          #   report = params[:incident]
          # else
            report = JSON.parse(params[:incident])
          # end
          
          report = BwReport.find_or_new_from_external_api(report)
          report.process_hash
          if report.save
            ProcessReportsWorker.perform_async('BwReport', report.id)
            msg = { success: 'Added the incident' }
            render json: msg and return
          else
            msg = { errors: report.errors.full_messages.to_sentence }
            render json: msg, status: :unprocessable_entity and return
          end
        else
          msg = { errors: 'You have to submit an incident' }
          render json: msg, status: :unprocessable_entity and return
        end
      end

    end
  end
end
