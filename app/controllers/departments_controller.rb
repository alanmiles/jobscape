class DepartmentsController < ApplicationController
  
  before_filter :authenticate
  before_filter :started_business_session
  before_filter :correct_business
  
  def index
    @business = Business.find(session[:biz])
    @title = "Departments"
    @departments = @business.current_departments.paginate(:page => params[:page])
  end

  def new
    @business = Business.find(params[:business_id])
    @title = "New department"
    @department = @business.departments.new
    @people = @business.all_current_employees
    @characters_left = 20
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
      flash[:success] = "'#{@department.name}' added."
      redirect_to business_departments_path(@business)
    else
      @title = "New department"
      @characters_left = 20 - @department.name.length
      @people = @business.all_current_employees
      render 'new'
    end
  end
  
  def show
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    @users = User.all_active_in(@department).paginate(:page => params[:page])
    session[:dept_id] = @department.id
    @title = "Department"
    store_location
  end

  def edit
    @department = Department.find(params[:id])
    @business = Business.find(@department.business_id)
    @title = "Edit department"
    @people = @business.all_current_employees
    @characters_left = 20 - @department.name.length
  end

  def update
   @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      flash[:success] = "Successfully updated."
      redirect_to @department
    else
      @title = "Edit department"
      @business = Business.find(@department.business_id)
      @characters_left = 20 - @department.name.length
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
        flash[:success] = "'#{@department.name}' has been removed from the list of current departments, 
             but it can be restored again later if necessary."
      else
    	@department.destroy
    	flash[:success] = "'#{@department.name}' has been completely removed."
      end
    end
    
    #redirect_to business_departments_path(@business)
    redirect_to :back
  end
  
end
