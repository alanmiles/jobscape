class LeaverMailer < ActionMailer::Base
  
  default :from => "alanpqs@gmail.com"
  
  def placement_cancelled(employee)
    @employee = Employee.find(employee)
    @user = User.find(@employee.user_id)
    @business = Business.find(@employee.business_id)
    mail(:to => @user.email, :subject => "HYGWIT: You're no longer with #{@business.name}.")
  end
  
  def resume_as_individual(employee)
    @employee = Employee.find(employee)
    @user = User.find(@employee.user_id)
    @business = Business.find(@employee.business_id)
    mail(:to => @user.email, :subject => "HYGWIT: You're no longer with #{@business.name}.")
  end
  
  def resume_as_jobseeker(employee)
    @employee = Employee.find(employee)
    @user = User.find(@employee.user_id)
    @business = Business.find(@employee.business_id)
    mail(:to => @user.email, :subject => "HYGWIT: You're no longer with #{@business.name}.")
  end
end
