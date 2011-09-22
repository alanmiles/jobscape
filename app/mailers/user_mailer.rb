class UserMailer < ActionMailer::Base
  
  default :from => "alanpqs@gmail.com"
  
  def registration_confirmation(user)  
    mail(:to => user.email, :subject => "Registered")  
  end
  
  def attribute_approved(quality, user)
    @user = user
    @quality = quality
    mail(:to => user.email, :subject => "Attribute Approved")  
  end
  
  def attribute_rejected(quality, user)
    @user = user
    @quality = quality
    mail(:to => user.email, :subject => "Attribute Rejected")  
  end  
end
