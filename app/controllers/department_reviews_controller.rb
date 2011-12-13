class DepartmentReviewsController < ApplicationController
  
  def index
    @business = Business.find(session[:biz])
    @departments = @business.current_departments
    session[:dept_id] = nil
    @title = "Reviews by department"
  end
  
  def show
    @department = Department.find(params[:id])
    @users = @department.current_team
    @business = Business.find(session[:biz])
    session[:dept_id] = @department.id
    @title = "Department team - reviews record"
  end

end
