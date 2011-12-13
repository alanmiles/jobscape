class VacanciesController < ApplicationController
  
  before_filter :authenticate
  before_filter :correct_officer
  
  def index
    @job = Job.find(session[:jobid])
    @vacancies = @job.unfilled_vacancies
    @title = "Vacancies for #{@job.job_title}"
  end

  def new
    @business = Business.find(session[:biz])
    @job = Job.find(session[:jobid])
    @vacancy = Vacancy.new
    @vacancy.job_id = @job.id
    @vacancy.sector_id = @business.sector_id
    @vacancy.close_date = Date.today + 14.days
    @vacancy.contact_person = current_user.name
    @title = "New vacancy"
  end
  
  def create
    @vacancy = Vacancy.new(params[:vacancy])
    if @vacancy.save
      flash[:success] = "The vacancy has been added.  This is the summary jobseekers will see."
      redirect_to @vacancy
    else
      @title = "New vacancy"
      @business = Business.find(session[:biz])
      @job = Job.find(session[:jobid])
      @vacancy.job_id = @job.id
      @vacancy.sector_id = @business.sector_id
      @vacancy.close_date = Date.today + 14.days
      @vacancy.contact_person = current_user.name
      render 'new'
    end
  end
  
  def show
    @vacancy = Vacancy.find(params[:id])
    @title = "Vacancy announcement"
    @job = Job.find(@vacancy.job_id)
    @details_link = true
  end
  
  def edit
    @vacancy = Vacancy.find(params[:id])
    @title = "Edit vacancy"
    @job = Job.find(session[:jobid])
  end
  
  def update
    @vacancy = Vacancy.find(params[:id])
    if @vacancy.update_attributes(params[:vacancy])
      flash[:success] = "Vacancy updated."
      redirect_to @vacancy
    else
      @title = "Edit vacancy"
      @job = Job.find(session[:jobid])
      render 'edit'
    end
  end
  
  def destroy
    @vacancy = Vacancy.find(params[:id])
    @job = Job.find(@vacancy.job_id)
    #ADD EXCLUSION iF VACANCY HAS APPLICANTS
    if @vacancy.filled?
      flash[:error] = "You can't delete a vacancy that's been filled - it's stored in history."
      redirect_to @vacancy
    else
      @vacancy.destroy
      flash[:success] = "#Vacancy for #{@job.job_title} deleted."
      if @job.has_vacancies?
        redirect_to vacancies_path
      else
        redirect_to @job
      end
    end
  end
end
