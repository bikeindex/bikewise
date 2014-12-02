module API
  module V1
    class Types < API::V1::Root
      include API::V1::Defaults

      resource :types do
        helpers do 
          def find_selections
            if params[:include_user_created] && params[:include_user_created] != 'undefined'
              @selections = Selection.all
            else
              @selections = Selection.default
            end
            @selections
          end
        end

        desc "Return all the selections"
        params do 
          optional :include_user_created, type: Boolean, default: 0, desc: 'Include user submitted types instead of default types.'
        end
        get do
          find_selections
          render @selections
        end
      
        desc "Return selections for a given type"
        params do
          requires :select_type, type: String, desc: 'Selection type', values: Selection.possible_types
          optional :include_user_created, type: Boolean, default: false, desc: 'Include user submitted types (instead of only default types)'
        end
        get ':select_type' do 
          find_selections
          @selections = @selections.where(select_type: params[:select_type])
          render @selections
        end
      end
    end
  end
end