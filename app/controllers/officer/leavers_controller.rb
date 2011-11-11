class Officer::LeaversController < ApplicationController
  
  before_filter :authenticate
  before_filter :officer_user
  before_filter :started_business_session
  before_filter :correct_business
  
  def index
    @business = Business.find(session[:biz])
    @leavers = @business.all_former_employees.paginate(:page => params[:page])
    @title = "Leavers"
  end

  def destroy
    @user = User.find(params[:id])
    @business = Business.find(session[:biz])
    @employee = Employee.find_by_business_id_and_user_id(@business, @user)
    @employee.destroy
    @jobs = @user.jobs.where("jobs.business_id = ?", @business)
    @jobs.each do |job|
      @placement = Placement.find_by_user_id_and_job_id(@user, job)
      @placement.destroy
    end
    flash[:success] = "All records for #{@user.name} at #{@business.name} have been removed"
    redirect_to officer_leavers_path
  end

end
