class OutlinesController < ApplicationController
  
  before_filter :authenticate
  #before_filter :not_admin_user
  before_filter :correct_job
  
  def show
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @business = Business.find(@job.business_id)
    @outline = @job.outline
    session[:outline_type] = nil
    @title = "Job summary"
  end
  
  def edit
    @outline = Outline.find(params[:id])
    @title = "Edit job summary"
    @job = Job.find(@outline.job_id)
    @role_left = 500 - @outline.role.length
    @qualities_left = 500 - @outline.qualities.length
    @importance_left = 500 - @outline.importance.length
  end
  
  def role
    @outline = Outline.find(params[:id])
    session[:outline_type] = "role"
    @title = "Edit job role"
    @job = Job.find(@outline.job_id)
    @characters_left = 500 - @outline.role.length
  end
  
  def qualities
    @outline = Outline.find(params[:id])
    session[:outline_type] = "qualities"
    @title = "Edit job qualities"
    @job = Job.find(@outline.job_id)
    @characters_left = 500 - @outline.qualities.length
  end
  
  def importance
    @outline = Outline.find(params[:id])
    session[:outline_type] = "importance"
    @title = "Edit job importance"
    @job = Job.find(@outline.job_id)
    @characters_left = 500 - @outline.importance.length 
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
      @job = Job.find(@outline.job_id)
      if session[:outline_type] == "role"
        @title = "Edit job role"
        @characters_left = 500 - @outline.role.length
        render 'role'
      elsif session[:outline_type] == "qualities"
        @title = "Edit job qualities"
        @characters_left = 500 - @outline.qualities.length
        render 'qualities'
      elsif session[:outline_type] == "importance"
        @title = "Edit job importance"
        @characters_left = 500 - @outline.role.importance
        render 'importance'
      else
        @title = "Edit job summary"
        @job = Job.find(@outline.job_id)
        @role_left = 500 - @outline.role.length
        @qualities_left = 500 - @outline.qualities.length
        @importance_left = 500 - @outline.importance.length
        render 'edit'
      end
    end
  end
  
end
