class DepartmentsController < ApplicationController
  
  before_filter :authenticate
  before_filter :started_business_session
  before_filter :correct_business
  
  def index
    @business = Business.find(session[:biz])
    @title = "Departments at #{@business.name}"
    @departments = @business.departments.order("departments.name").paginate(:page => params[:page]) 
  end

  def new
    @business = Business.find(params[:business_id])
    @title = "Add a department"
    @department = @business.departments.new
    @people = @business.users.order("users.name")
    @characters_left = 50
  end

  def create
    @user = current_user
    @business = Business.find(session[:biz])
    @department = @business.departments.new(params[:department])
    if @department.save
      flash[:success] = "#{@department.name} added."
      redirect_to business_departments_path(@business)
    else
      @title = "Add a department"
      @characters_left = 50 - @department.name.length
      @people = @business.users.order("users.name")
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
    @people = @business.users.order("users.name")
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
      @people = @business.users.order("users.name")
      render 'edit'
    end 
  end
  
  def destroy
  
  end
  
end
