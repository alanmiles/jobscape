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
        @path = admin_path
      elsif current_user.account == 1
        @path = user_home_path
      elsif current_user.account == 2
        @path = jobseeker_home_path
      elsif current_user.account == 3
        @path = officer_home_path
      else
        @path = employee_home_path
      end
      
      if current_user.no_pending_invitation?
        redirect_back_or @path
      else
        @invitation = current_user.pending_invitation
        redirect_to edit_invitation_path(@invitation)
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

