class QualificationsController < ApplicationController
  
  before_filter :authenticate
  before_filter :not_admin_user
  before_filter :correct_job
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @qualifications = @plan.qualifications.order("position")
  end
  
  def sort
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @plan.qualifications.each do |f|
      f.position = params["qlfctn"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @qualification = @plan.qualifications.new
    @title = "New qualification"
  end
  
  def create
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @qualification = @plan.qualifications.new(params[:qualification])
    if @qualification.save
      flash[:success] = "Qualification added"
      redirect_to plan_qualifications_path(@plan)
    else
      @title = "New qualification"
      render 'new'
    end
  end
  
  def edit
    @qualification = Qualification.find(params[:id])
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @title = "Edit qualification"
  end
  
  def update
    @qualification = Qualification.find(params[:id])
    if @qualification.update_attributes(params[:qualification])
      flash[:success] = "Qualification updated."
      redirect_to plan_qualifications_path(@qualification.plan_id)
    else
      @title = "Edit qualification"
      @job = Job.find(session[:jobid])
      @plan = Plan.find_by_job_id(@job.id)
      render 'edit'
    end
  end

  def destroy
    @qualification = Qualification.find(params[:id]).destroy
    flash[:success] = "Qualification removed."
    redirect_to plan_qualifications_path(@qualification.plan_id)
  end
end
