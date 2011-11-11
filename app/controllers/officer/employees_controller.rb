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
      if @employee.left?
        
        #cancel all employee placements
        @user = User.find(@employee.user_id)
        @business = Business.find(@employee.business_id)
        @user.deactivate_current_placement(@business)
        
        flash[:success] = "#{@employee.user.name} has now left the business - but you can still see the records
                          in 'Former employees'"
        redirect_to officer_users_path
      else
        flash[:success] = "Employee details updated."
        redirect_to officer_user_path(@employee.user_id)
      end
    else
      @title = "Edit employee details"
      render 'edit'
    end
  end

end
