class MySubmissionsController < ApplicationController
  
  def index
    @qualities = Quality.where("created_by =?", current_user.id).order("created_at DESC")
    @title = "My Attribute Suggestions"
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job)
    session[:return_to] = my_submissions_path
  end

  def show
    @quality = Quality.find(params[:id])
    @title = "My submission: #{@quality.quality}"
    @pams = @quality.pams
  end
  
  def destroy
    @submission = Quality.find(params[:id]).destroy
    flash[:success] = "'#{@submission.quality}' and all associated PAMs removed."
    redirect_to my_submissions_path
  end
  
end
