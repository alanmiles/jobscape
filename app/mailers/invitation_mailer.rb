class InvitationMailer < ActionMailer::Base
  
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
end
