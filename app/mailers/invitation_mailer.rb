class InvitationMailer < ActionMailer::Base
  
  def hygwit_invitation(invitation)
    @invitation = Invitation.find(invitation.id)
    @sender = User.find(@invitation.inviter_id)
    mail(:to => @invitation.email, :from => @sender.name, :subject => "Invitation to HYGWIT, our achievement management website")
  end
end
