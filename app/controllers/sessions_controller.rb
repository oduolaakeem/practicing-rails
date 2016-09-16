class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if user_authenticated?
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or_to @user
      else
        flash[:warning] = "Account not activated.\nCheck your email for the activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def user_authenticated?
      @user && @user.authenticate(params[:session][:password])
    end
end
