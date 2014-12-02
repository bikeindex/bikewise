module API
  module V1
    class Types < API::V1::Root
      include API::V1::Defaults

      resource :types do
        helpers do 
          def find_selections
            @selections = params[:include_user_created] ? Selection.all : Selection.default
          end
        end
        desc "Return all the selections"
        params do 
          optional :include_user_created, type: Boolean, default: false, desc: 'Include user submitted types instead of default types.'
        end
        get do
          find_selections
          render @selections
        end
      

        desc "Return selections for a given type"
        params do
          requires :select_type, type: String, desc: 'Incident id.', values: Selection.possible_types
          optional :include_user_created, type: Boolean, default: false, desc: 'Include user submitted types instead of default types.'
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