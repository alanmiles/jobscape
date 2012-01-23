class MyApplicationsController < ApplicationController
  
  def index
    @user = current_user
    @applications = Application.where("user_id = ? and next_action = ? and submitted = ?", @user, 2, true).order("updated_at DESC").paginate(:page => params[:page]) 
    @title = "Your live applications"
    store_location
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
    @application.submission_date = Time.now
  end
  
  def update
    @application = Application.find(params[:id])
    @old_status = @application.next_action
    if @application.update_attributes(params[:application])
      if @application.submitted?
        @q_score = @application.sum_of_qualities
        @r_score = @application.sum_of_requirements
        @b_score = @application.sum_of_responsibilities
        @application.update_attributes(:qualities_score => @q_score, :requirements_score => @r_score, :responsibilities_score => @b_score)
        @application.calculate_hygwit_score
        flash[:success] = "Your application for job ref ##{@application.vacancy_id} has now been sent.  Now check the application again."
        redirect_to my_application_path(@application)
      else
        if @old_status == 2
          flash[:notice] = "Earlier you submitted the application, but now you've withdrawn it.  Is this what you really 
            wanted to do?  If not, then please return to the application form, and re-submit."
        else       
          flash[:success] = "Your changes have been saved, but you haven't yet applied for job ref ##{@application.vacancy_id}."
        end  
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
  
  def show
    @application = Application.find(params[:id])
    @vacancy = Vacancy.find(@application.vacancy_id)
    @job = Job.find(@vacancy.job_id)
    @plan = Plan.find_by_job_id(@job.id)
    @outline = Outline.find_by_job_id(@job.id)
    @responsibilities = @application.applicresponsibilities
    @qualities = @application.applicqualities
    @requirements = @application.applicrequirements
    @title = "Review your application"
  end
  
  def destroy
    @application = Application.find(params[:id])
    @vacancy = Vacancy.find(@application.vacancy_id)
    @application.destroy
    flash[:success] = "You have cancelled your application for Vacancy ref ##{@vacancy.id} - #{@vacancy.headline}."
    #redirect_to my_applications_path
    redirect_to :back
  end
end
