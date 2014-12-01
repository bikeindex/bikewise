module API
  module V1
    class Incidents < Grape::API
      include API::V1::Defaults
      resource :incidents do
        desc "Return paginated incidents matching parameters"
        get do
          incidents = find_incidents
          page = params[:page]
          page ||= 1
          per_page = params[:per_page]
          per_page ||= 10
          incidents = incidents.page(page).per(per_page)
          page_data = {
            page: incidents.current_page,
            per_page: per_page,
            next_page: incidents.next_page,
            prev_page: incidents.prev_page,
            pages: incidents.total_pages,
            total_count: incidents.total_count
          }
          render incidents, { meta: page_data, meta_key: :pagination_info }
        end

        desc "Return a single incident" 
        get ':id' do 
          incident = Incident.find(params[:id])
          render incident
        end
      end
    end
  end
end