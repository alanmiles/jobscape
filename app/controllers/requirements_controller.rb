class RequirementsController < ApplicationController
  
  before_filter :authenticate
  before_filter :not_admin_user
  before_filter :correct_job
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @requirements = @plan.requirements.order("position")
    @title = "Hiring Requirements"
  end

  def sort
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @plan.requirements.each do |f|
      f.position = params["req"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @requirement = @plan.requirements.new
    @title = "New requirement"
  end
  
  def create
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @requirement = @plan.requirements.new(params[:requirement])
    if @requirement.save
      flash[:success] = "Requirement added"
      redirect_to plan_requirements_path(@plan)
    else
      @title = "New requirement"
      render 'new'
    end
  end
  
  def edit
    @requirement = Requirement.find(params[:id])
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @title = "Edit requirement"
  end
  
  def update
    @requirement = Requirement.find(params[:id])
    if @requirement.update_attributes(params[:requirement])
      flash[:success] = "Requirement updated."
      redirect_to plan_requirements_path(@requirement.plan_id)
    else
      @title = "Edit requirement"
      @job = Job.find(session[:jobid])
      @plan = Plan.find_by_job_id(@job.id)
      render 'edit'
    end
  end

  def destroy
    @requirement = Requirement.find(params[:id]).destroy
    flash[:success] = "Requirement removed."
    redirect_to plan_requirements_path(@requirement.plan_id)
  end

end