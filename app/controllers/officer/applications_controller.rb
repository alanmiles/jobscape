class Officer::ApplicationsController < ApplicationController
  
  def index
    @vacancy = Vacancy.find(params[:vacancy_id])
    @applications = @vacancy.applications
    @title = "Applications"
  end
  
  def show
    @application = Application.find(params[:id])
    @applicant = User.find(@application.user_id)
    @portrait = @applicant.portrait
    @vacancy = Vacancy.find(@application.vacancy_id)
    @job = Job.find(@vacancy.job_id)
    @plan = Plan.find_by_job_id(@job.id)
    @outline = Outline.find_by_job_id(@job.id)
    @responsibilities = @application.applicresponsibilities
    @qualities = @application.applicqualities
    @requirements = @application.applicrequirements
    @title = "Application details"
    @actions = Application::EMPLOYER_DECISIONS
  end
  
  def update
    @application = Application.find(params[:id])
    if @application.update_attributes(params[:application])
      flash[:success] = "The application status has been updated"
      redirect_to officer_application_path(@application)
    else
      @applicant = User.find(@application.user_id)
      @portrait = @applicant.portrait
      @vacancy = Vacancy.find(@application.vacancy_id)
      @job = Job.find(@vacancy.job_id)
      @plan = Plan.find_by_job_id(@job.id)
      @outline = Outline.find_by_job_id(@job.id)
      @responsibilities = @application.applicresponsibilities
      @qualities = @application.applicqualities
      @requirements = @application.applicrequirements
      @title = "Full application details"
      @actions = Application::EMPLOYER_DECISIONS
      render 'show'
    end
  end

end
