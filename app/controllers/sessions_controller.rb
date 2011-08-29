class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      if current_user.admin?
        redirect_back_or admin_path
      else
        redirect_back_or user_home_path
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end

