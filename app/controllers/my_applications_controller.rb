class MyApplicationsController < ApplicationController
  
  def index
    @user = current_user
    @applications = Application.where("user_id = ? and next_action = ? and submitted = ?", @user, 2, true).order("created_at DESC").paginate(:page => params[:page]) 
    @title = "My applications"
  end

  def edit
    @application = Application.find(params[:id])
    @title = "Finalize application details"
    @vacancy = Vacancy.find(@application.vacancy_id)
    @r_scores = Applicresponsibility::RESPONSIBILITY_SCORES
    @q_scores = Applicquality::ATTRIBUTE_SCORES
    @req_scores = Applicrequirement::REQUIREMENT_SCORES
    @job = Job.find(@vacancy.job_id)
    @outline = Outline.find_by_job_id(@job.id)
    @application.submission_date = Date.today
  end
  
  def update
    @application = Application.find(params[:id])
    if @application.update_attributes(params[:application])
      if @application.submitted?
        @q_score = @application.sum_of_qualities
        @r_score = @application.sum_of_requirements
        @b_score = @application.sum_of_responsibilities
        @application.update_attributes(:qualities_score => @q_score, :requirements_score => @r_score, :responsibilities_score => @b_score)
        flash[:success] = "Your application for job ref ##{@application.vacancy_id} has now been sent."
        redirect_to my_applications_path
      else
        flash[:success] = "Your changes have been saved, but you haven't yet applied for job ref ##{@application.vacancy_id}."
        redirect_to incomplete_applications_path
      end
    else
      @title = "Finalize application details"
      @vacancy = Vacancy.find(@application.vacancy_id)
      @r_scores = Applicresponsibility::RESPONSIBILITY_SCORES
      @a_qualities = @application.applicqualities.order("position")
      @q_scores = Applicquality::ATTRIBUTE_SCORES
      @a_requirements = @application.applicrequirements.order("position")
      @req_scores = Applicrequirement::REQUIREMENT_SCORES
      render 'edit'
    end
  end
end
