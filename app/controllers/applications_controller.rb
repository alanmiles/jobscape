class ApplicationsController < ApplicationController
  
  def index
  end
  
  def new
    @vacancy = Vacancy.find(params[:vacancy_id])
    @user = current_user
    @application = @vacancy.applications.build
    @application.user_id = @user.id if signed_in?
    @actions = Application::ACTION_TYPES
    @job = Job.find(@vacancy.job_id)
    @outline = Outline.find_by_job_id(@job.id)
    @plan = Plan.find_by_job_id(@job.id)
    @responsibilities = @plan.top_five_responsibilities
    @qualities = @plan.top_five_attributes
    @requirements = @plan.top_five_requirements
    @title = "Job vacancy"
  end

  def create
    @vacancy = Vacancy.find(params[:vacancy_id])
    @application = @vacancy.applications.new(params[:application])
    if @application.next_action == 0
      flash[:notice] = "You decided not to bookmark or apply for vacancy ##{@vacancy.id} - #{@vacancy.headline}"
      redirect_to latest_vacancies_path
    else
      if @application.save
        if @application.next_action == 1
          flash[:success] = "You successfully bookmarked vacancy ##{@vacancy.id} - #{@vacancy.headline}."
          redirect_to latest_vacancies_path
        else
          flash[:notice] = "Now complete this questionnaire to complete your application."
          redirect_to edit_my_application_path(@application)
        end   
      else
        @user = current_user
        @application.user_id = @user.id
        @actions = Application::ACTION_TYPES
        @job = Job.find(@vacancy.job_id)
        @outline = Outline.find_by_job_id(@job.id)
        @plan = Plan.find_by_job_id(@job.id)
        @responsibilities = @plan.top_five_responsibilities
        @qualities = @plan.top_five_attributes
        @requirements = @plan.top_five_requirements
        @title = "Shortlist or apply?"
        flash[:error] = "Your application could not be completed. Please try again."
        render 'new'
      end
    end
  end
  
  def show
    @application = Application.find(params[:id])
    @title = "Job Application"
  end
  
  def edit
    @application = Application.find(params[:id])
    @title = "Finalize application details"
    @vacancy = Vacancy.find(@application.vacancy_id)
    if @application.personal_statement.empty?
      @characters_left = 255
    else
      @characters_left = 255 - @application.personal_statement.length
    end   
  end
  
end
