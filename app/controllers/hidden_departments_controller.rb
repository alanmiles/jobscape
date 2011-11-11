class HiddenDepartmentsController < ApplicationController
  
  def index
    @business = Business.find(params[:business_id])
    @departments = @business.hidden_departments 
    @title = "Archived departments"
  end

  def edit
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    @title = "Reactivate department"
    @people = @business.all_current_employees
  end

  def update
   @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      if @department.hidden == false
        flash[:success] = "#{@department.name} successfully reactivated."
        redirect_to business_departments_path(@department.business_id)
      else
        @department.update_attributes(:manager_id => nil, :deputy_id => nil)
        flash[:notice] = "Your changes were dropped, because you left #{@department.name} inactive."
        redirect_to business_hidden_departments_path(@department.business_id)
      end
    else
      @title = "Reactivate department"
      @business = Business.find(@department.business_id)
      @people = @business.all_current_employees
      render 'edit'
    end 
  end
  
  def destroy
    @department = Department.find(params[:id])
    @business = Business.find(session[:biz])
    
    if @department.has_inactive_jobs?
      flash[:success] = "#{@department.name} still has related archived jobs, so it can't be deleted" 
    else
      @department.destroy
      flash[:success] = "#{@department.name} has been completely removed."
    end
  
    redirect_to business_hidden_departments_path(@business)
  end
  
end
