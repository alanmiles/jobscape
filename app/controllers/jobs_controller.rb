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
    @title = "New job: #{@business.name}"
    @job = @business.jobs.new
    @occupations = Occupation.find(:all, :order => "name")
    @characters_left = 50
  end
  
  def create
    @business = Business.find(session[:biz])
    @job = @business.jobs.new(params[:job])
    if @job.save
      flash[:success] = "#{@job.job_title} added."
      redirect_to business_jobs_path(@business)
    else
      @title = "New job: #{@business.name}"
      @characters_left = 50 - @job.job_title.length
      @occupations = Occupation.find(:all, :order => "name")
      render 'new'
    end
  end
  
  def edit
    @job = Job.find(params[:id])
    @business = Business.find_by_id(@job.business_id)
    @title = "Edit job: #{@job.business.name}"
    @occupations = Occupation.find(:all, :order => "name")
    @characters_left = 50 - @job.job_title.length
  end
  
  def update
   @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:success] = "Successfully updated."
      redirect_to job_path(@job)
    else
      @title = "Edit job: #{@job.business.name}"
      @business = Business.find_by_id(@job.business_id)
      @characters_left = 50 - @job.job_title.length
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
  
  private
  
    def started_business_session
      unless business_session?
        flash[:notice] = "First a business needs to be selected."
        redirect_to root_path
      end
    end
  
    def correct_business
      @user = current_user
      @business = Business.find(session[:biz])
      total = Employee.count(
          :conditions => ["user_id = ? and business_id = ?", @user, @business])
      if total == 0
        flash[:error] = "Illegal procedure. You can only access jobs in your own business."
        redirect_to root_path
      end
    end

end
