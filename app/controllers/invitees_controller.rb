class InviteesController < ApplicationController
  
  def new
    sign_out if signed_in?
    @title = "Welcome to HYGWIT"
  end
  
  def create
    @name = params[:invitee][:name]
    @code = params[:invitee][:security_code]
    @invitation = Invitation.find_by_name_and_security_code(@name, @code)
    
    if @invitation.nil?
      flash.now[:error] = "Invalid name and security code combination.  Please check your invitation email and try again."
      @title = "Welcome to HYGWIT"
      render 'new'
    else
      session[:invited] = @invitation.id
      redirect_to signup_path     
    end
  end

end
