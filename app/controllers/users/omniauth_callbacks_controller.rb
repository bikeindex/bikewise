class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def bike_index
    # puts request.env["omniauth.auth"]
    # puts "\n\n\n"
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "BikeIndex") if is_navigational_format?
    else
      puts request.env["omniauth.auth"]
      flash[:error] = "We're sorry, we failed to sign you in. Please contact admin@bikeindex.org"
      redirect_to root_url
    end
  end
end