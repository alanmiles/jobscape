class OutlinesController < ApplicationController
  
  before_filter :authenticate
  before_filter :not_admin_user
  before_filter :correct_job
  
  def show
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @outline = @job.outline
    @title = "Job summary"
  end
  
  def edit
    @outline = Outline.find(params[:id])
    @title = "Edit job summary"
    @job = Job.find(@outline.job_id)
  end
  
  def update
    @outline = Outline.find(params[:id])
    if @outline.update_attributes(params[:outline])
      if @outline.complete?
        flash[:success] = "Job Summary successfully updated."
      else
        flash[:success] = "Your changes have been recorded, but there's still further work required on the Job Summary."
      end
      redirect_to @outline
    else
      @title = "Edit job summary"
      @job = Job.find(@outline.job_id)
      render 'edit'
    end
  end
  
end
