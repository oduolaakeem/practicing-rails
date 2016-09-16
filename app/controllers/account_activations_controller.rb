class AccountActivationsController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    if user_not_activated?
      @user.activate
      log_in @user
      flash[:success] = "Account activated!"
      redirect_to @user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

  private

    def user_not_activated?
      @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
    end
end
