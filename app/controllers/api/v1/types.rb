module API
  module V1
    class Types < API::V1::Root
      include API::V1::Defaults
      resource :types do 
        desc "Return the selection types for the given type"
        get do
          selections = params[:user_created] ? Selection.all : Selection.default
          selections = selections.where(select_type: params[:type]) if params[:type]
          render selections
        end
      end
    end
  end
end