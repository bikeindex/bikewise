class Users::RegistrationsController < Devise::RegistrationsController
  
  def new
    redirect_to user_omniauth_authorize_path(:bike_index) and return
  end

end