class DepartmentsController < ApplicationController
  
  before_filter :authenticate
  before_filter :started_business_session
  before_filter :correct_business
  
  def index
    @business = Business.find(session[:biz])
    @title = "Departments at #{@business.name}"
    @departments = @business.current_departments.paginate(:page => params[:page]) 
  end

  def new
    @business = Business.find(params[:business_id])
    @title = "Add a department"
    @department = @business.departments.new
    @people = @business.all_current_employees
    @characters_left = 50
  end

  def create
    @user = current_user
    @business = Business.find(session[:biz])
    @department = @business.departments.new(params[:department])
    @name = params[:department][:name]
    if Department.inactive_discovered?(@business, @name)
      @department = Department.find_by_business_id_and_name_and_hidden(@business.id, @name, true)
      @department.hidden = false
      @department.manager_id = params[:department][:manager_id]
      @department.deputy_id = params[:department][:deputy_id]
    end
    if @department.save
      flash[:success] = "#{@department.name} added."
      redirect_to business_departments_path(@business)
    else
      @title = "Add a department"
      @characters_left = 50 - @department.name.length
      @people = @business.all_current_employees
      render 'new'
    end
  end
  
  def show
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    @title = "Department at #{@business.name}"
  end

  def edit
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    @title = "Edit department details"
    @people = @business.all_current_employees
  end

  def update
   @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      flash[:success] = "Successfully updated."
      redirect_to @department
    else
      @title = "Edit department details"
      @business = Business.find(@department.business_id)
      @characters_left = 50 - @department.name.length
      @people = @business.all_current_employees
      render 'edit'
    end 
  end
  
  def destroy
    @department = Department.find(params[:id])
    @business = Business.find(session[:biz])
    
    if @department.has_active_jobs?
      flash[:error] = "At least one job is still active in this department, so it can't be deleted or hidden."
    else
      if @department.has_inactive_jobs?
        @department.update_attributes(:hidden => true, :manager_id => nil, :deputy_id => nil)
        flash[:success] = "#{@department.name} has been removed from the list of current departments, 
             but it can be restored again later if necessary."
      else
    	@department.destroy
    	flash[:success] = "#{@department.name} has been completely removed."
      end
    end
    
    redirect_to business_departments_path(@business)
  end
  
end