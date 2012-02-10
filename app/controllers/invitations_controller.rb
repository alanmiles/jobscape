class InvitationsController < ApplicationController
  
  
  def index
    @business = Business.find(session[:biz])
    @invitations = @business.invitations.paginate(:page => params[:page])
    @title = "Invitations"
  end

  def new
    @business = Business.find(params[:business_id])
    @jobs = @business.available_jobs
    @code = Invitation.generate_code
    @invitation = @business.invitations.build(:inviter_id => current_user.id, :security_code => @code)
    @title = "Send an invitation"
  end
  
  def create
    @business = Business.find(params[:business_id])
    @invitation = @business.invitations.new(params[:invitation])
    if @invitation.save
      #determine whether the invitee already has a HYGWIT account
      #No account
      unless @invitation.corresponds_to_user?
        InvitationMailer.hygwit_invitation(@invitation).deliver
        flash[:success] = "Your invitation has been emailed to #{@invitation.name}." 
      else
      #has an account already
        InvitationMailer.existing_user(@invitation).deliver
        flash[:success] = "Your invitation has been emailed to #{@invitation.name}, who's already a HYGWIT user." 
      end
      redirect_to business_invitations_path(@business)
    else
      @jobs = @business.available_jobs
      @code = Invitation.generate_code
      @title = "Send an invitation"
      render 'new'
    end
  end
  
  def edit
    @invitation = Invitation.find(params[:id])
    @user = current_user
    @inviter = User.find(@invitation.inviter_id)
    @title = "Accept HYGWIT invitation"
  end
  
  def update
    @invitation = Invitation.find(params[:id])
    @user = current_user
    @inviter = User.find(@invitation.inviter_id)
    if @invitation.update_attributes(params[:invitation])
      if @invitation.signed_up?

        #Set Staff Number     
        @business = Business.find(@invitation.business_id)
        if @invitation.staff_no == nil
          @top_ref = @business.next_ref_no
        else
          @top_ref = @invitation.staff_no
        end
        @job = Job.find(@invitation.job_id)
        
        #Set a new Employee record
        @employee = Employee.new(:business_id => @business.id,
          		:user_id => @user.id,
          		:ref_no => @top_ref)
        @employee.save
          
        #Set a new Placement record
        @placement = Placement.new(:user_id => @user.id,
          		:job_id => @invitation.job_id,
          		:started_job => Date.today)
        @placement.save
        
        #Adjust the User.account type
        if @user.account < 3
          @user.update_attribute(:account, 4)
          flash[:success] = "You've accepted the invitation, and you can now access your new Employee account."
        else
          flash[:success] = "You've accepted the invitation from #{@invitation.business.name}."
        end
        
        #Remove the invitation - no longer required
        @invitation.destroy        

      else
        flash[:notice] = "You haven't yet accepted the invitation from #{@invitation.business.name}.  Remember that you can mail #{@inviter.name}
                   at #{@inviter.email} if you want to cancel the invitation."
         
      end
      
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
      redirect_to @path    
    
    else
    
      @user = current_user
      @inviter = User.find(@invitation.inviter_id)
      @title = "Accept HYGWIT invitation"
      render 'edit'
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @business = Business.find(session[:biz])
    @invitation.destroy
    flash[:success] = "Invitation to #{@invitation.name} successfully removed."
    #redirect_to business_invitations_path(@business) 
    redirect_to :back
  end
end
