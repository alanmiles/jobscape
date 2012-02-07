class MySubmissionsController < ApplicationController
  
  def index
    @qualities = Quality.where("created_by =?", current_user.id).order("created_at DESC")
    @title = "Your attribute suggestions"
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job)
    store_location
  end

  def show
    @quality = Quality.find(params[:id])
    @title = "Your submission"
    @pams = @quality.pams
  end
  
  def destroy
    @submission = Quality.find(params[:id]).destroy
    flash[:success] = "'#{@submission.quality}' and all associated grade descriptors removed."
    redirect_to my_submissions_path
  end
  
end
