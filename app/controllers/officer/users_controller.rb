class Officer::UsersController < ApplicationController
  
  before_filter :authenticate
  before_filter :officer_user
  before_filter :started_business_session
  before_filter :correct_business
  
  def index
    @business = Business.find(session[:biz])
    @users = @business.all_current_employees.paginate(:page => params[:page])
    @title = "HYGWIT Users"
  end
  
  def show
    @user = User.find(params[:id])
    @business = Business.find(session[:biz])
    unless session[:dept_id] == nil
      @department = Department.find(session[:dept_id])    
    end
    @employee = @user.employee_lookup(@business)
    unless @user.no_current_job?(@business)
      @job = Job.find(@user.current_job(@business)) 
      @placement = @user.current_placement(@business)
    end
    if @user.has_previous_jobs?(@business)
      @prev_jobs = @user.previous_jobs(@business)
    end
    @title = "User details"
  end

end
