class AccountController < ApplicationController
  before_filter :authenticate_user!
  def index
    @bodyclass = 'account'
    @account = current_user
  end

  def update
    @account = current_user
    @bodyclass = 'account'
    if @account.update(user_params)
      flash[:notice] = 'You successfully updated yourself.'
      # sign_in @user, :bypass => true
      render action: :index
    else
      render action: :index, error: 'Whoops, problem with your update'
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # params.require(:user).permit(:email, :password)
      params.required(:user).permit(:legacy_bw_email, :birth_year)
    end



end