class Officer::EmployeesController < ApplicationController
  
  before_filter :authenticate
  before_filter :officer_user
  before_filter :started_business_session
  before_filter :correct_business
  
  def edit
    @employee = Employee.find(params[:id])
    @title = "Edit employee details"
  end
  
  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      flash[:success] = "Employee details updated."
      redirect_to officer_user_path(@employee.user_id)
    else
      @title = "Edit employee details"
      render 'edit'
    end
  end

end
