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
      elsif current_user.account == 1
        redirect_back_or user_home_path
      elsif current_user.account == 2
        redirect_back_or jobseeker_home_path
      elsif current_user.account == 3
        redirect_back_or officer_home_path
      else
        redirect_back_or employee_home_path
      end
    end
  end
  
  def destroy
    sign_out
    session[:jobid] = nil
    session[:return_to] = nil
    session[:biz] = nil
    redirect_to root_path
  end
end

