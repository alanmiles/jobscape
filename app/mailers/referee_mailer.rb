class RefereeMailer < ActionMailer::Base
  
  default :from => "alanpqs@gmail.com"
  
  def request_response(referee)
    @referee = Referee.find(referee)
    @user = User.find(@referee.user_id)
    mail(:to => @referee.email, :subject => "Job reference requested for #{@user.name}")
  end
end
