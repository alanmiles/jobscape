class InvitationsController < ApplicationController
  
  
  def index
    @business = Business.find(session[:biz])
    @invitations = @business.invitations.paginate(:page => params[:page])
    @title = "HYGWIT invitations"
  end

  def new
    @business = Business.find(params[:business_id])
    @jobs = @business.jobs.order("job_title")
    @code = Invitation.generate_code
    @invitation = @business.invitations.build(:inviter_id => current_user.id, :security_code => @code)
    @title = "Send an invitation"
  end
  
  def create
    @business = Business.find(params[:business_id])
    @invitation = @business.invitations.new(params[:invitation])
    if @invitation.save
      InvitationMailer.hygwit_invitation(@invitation).deliver
      flash[:success] = "Your invitation has been emailed to #{@invitation.name}."
      redirect_to business_invitations_path(@business)
    else
      @jobs = @business.jobs.order("job_title")
      @code = Invitation.generate_code
      @title = "Send an invitation"
      render 'new'
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @business = Business.find(session[:biz])
    @invitation.destroy
    flash[:success] = "invitation to #{@invitation.name} successfully removed."
    redirect_to business_invitations_path(@business) 
  end
end
