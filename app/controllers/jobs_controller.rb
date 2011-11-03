class JobsController < ApplicationController
  before_filter :authenticate
  before_filter :started_business_session
  before_filter :correct_business
  
  def index
    @business = Business.find(session[:biz])
    @title = "Jobs at #{@business.name}"
    @jobs = @business.jobs.paginate(:page => params[:page]) 
    session[:jobid] = nil 
  end

  def show
    @job = Job.find(params[:id])
    session[:jobid] = @job.id
    @title = @job.job_title
    @plan = Plan.find_by_job_id(@job)
    @count_vacancies = Vacancy.sum_for(@job)
    @vacancy = Vacancy.find_by_job_id(@job) if @job.vacancy_record_count == 1
  end
  
  def new
    @business = Business.find(session[:biz])
    @title = "Add a job"
    @job = @business.jobs.new
    @user = current_user
    if @user.account == 1
      @dept = @business.departments.first
      @job.department_id = @dept.id
    end
    @departments = @business.departments.order("name")
    @occupations = Occupation.find(:all, :order => "name")
    @characters_left = 50
  end
  
  def create
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @business.jobs.new(params[:job])
    if @job.save
      flash[:success] = "#{@job.job_title} added."
      if @user.account == 1
        Placement.individual_make(@user, @job)
        redirect_to my_job_path
      else
        redirect_to business_jobs_path(@business)
      end
    else
      @title = "Add a job"
      @characters_left = 50 - @job.job_title.length
      @user = current_user
      if @user.account == 1
        @dept = @business.departments.first
        @job.department_id = @dept.id
      end
      @departments = @business.departments.order("name")
      @occupations = Occupation.find(:all, :order => "name")
      render 'new'
    end
  end
  
  def edit
    @job = Job.find(params[:id])
    @business = Business.find_by_id(@job.business_id)
    @title = "Edit job"
    @departments = @business.departments.order("name")
    @occupations = Occupation.find(:all, :order => "name")
    @characters_left = 50 - @job.job_title.length
  end
  
  def update
   @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:success] = "Successfully updated."
      redirect_to job_path(@job)
    else
      @title = "Edit job"
      @business = Business.find_by_id(@job.business_id)
      @characters_left = 50 - @job.job_title.length
      @departments = @business.departments.order("name")
      @occupations = Occupation.find(:all, :order => "name")
      render 'edit'
    end 
  
  end
  
  def destroy
    @job = Job.find(params[:id])
    @business = Business.find_by_id(session[:biz])
    #Add condition to ignore method if job is attached to employees
    @job.destroy
    flash[:success] = "#{@job.job_title} removed."
    redirect_to business_jobs_path(@business)
  end

end
