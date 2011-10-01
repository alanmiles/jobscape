module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def admin_user
    unless current_user.admin?
      flash[:notice] = "Only available to administrators"
      redirect_to root_path
    end
  end
  
  def not_admin_user
    if current_user.admin?
      redirect_to admin_path, :notice => "Not available to administrators"
    end
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def business_session?
    session[:biz]!= nil
  end
  
  def job_owner?
    if session[:jobid] == nil
      flash.now[:error] = "Illegal procedure - please use the buttons provided, not the URL, to access records."
      redirect_to root_path
    else
      @job = Job.find(session[:jobid])
      @business = Business.find(@job.business_id)
      found = Employee.where("business_id =? and user_id = ?", @business.id, current_user.id).count
      found == 1
    end
  end
  
  def correct_job
    unless job_owner?
      redirect_to root_path, :notice => "You can't deal with jobs outside your own business"      
    end  
  end
  
  def job_officer?
    if session[:jobid] == nil
      flash.now[:error] = "Illegal procedure - please use the buttons provided, not the URL, to access records."
      redirect_to root_path
    else
      @job = Job.find(session[:jobid])
      @business = Business.find(@job.business_id)
      found = Employee.where("business_id =? and user_id = ? and officer = ?", @business.id, current_user.id, true).count
      found == 1
    end
  end
  
  def correct_officer
    unless job_officer?
      redirect_to root_path, :notice => "You need to be an officer in the business for this action"      
    end  
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def sign_out
    cookies.delete(:remember_token)
    session[:biz] = nil
    session[:jobid] = nil
    session[:responid] = nil
    self.current_user = nil
  end
  
  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
  
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end

