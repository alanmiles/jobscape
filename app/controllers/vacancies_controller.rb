class VacanciesController < ApplicationController
  def index
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
      flash[:success] = "The vacancy has been added.  This is the summary applicants will see."
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
end
