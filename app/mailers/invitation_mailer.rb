class InvitationMailer < ActionMailer::Base
  
  default :from => "alanpqs@gmail.com"
  
  def hygwit_invitation(invitation)
    @invitation = Invitation.find(invitation.id)
    @sender = User.find(@invitation.inviter_id)
    mail(:to => @invitation.email, :from => @sender.name, :subject => "Invitation to HYGWIT, our achievement management website")
  end
  
  def existing_user(invitation)
    @invitation = Invitation.find(invitation.id)
    @business = Business.find(invitation.business_id)
    @job = Job.find(invitation.job_id)
    @sender = User.find(@invitation.inviter_id)
    mail(:to => @invitation.email, :from => @sender.name, :subject => "New HYGWIT invitation")
  end
  
  def recall_active_employee(placement)
    @placement = Placement.find(placement)
    @user = User.find(@placement.user_id)
    @job = Job.find(@placement.job_id)
    @business = Business.find(@job.business_id)
    mail(:to => @user.email, :subject => "HYGWIT: job reactivation")
  end
  
  def recall_inactive_employee(placement)
    @placement = Placement.find(placement)
    @user = User.find(@placement.user_id)
    @job = Job.find(@placement.job_id)
    @business = Business.find(@job.business_id)
    mail(:to => @user.email, :subject => "Change to HYGWIT access rights")
  end
  
end
