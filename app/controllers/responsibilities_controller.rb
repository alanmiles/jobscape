class ResponsibilitiesController < ApplicationController
  before_filter :authenticate
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @responsibilities = @plan.responsibilities.find(:all,
         :conditions => ["responsibilities.removed = ?", false],
         :order => "responsibilities.rating DESC")
    @title = "Responsibilities: #{@job.job_title}"
  end

  def show
    @responsibility = Responsibility.find(params[:id])
    @job = Job.find(session[:jobid])
    @title = "Responsibility for #{@job.job_title}"
    
  end
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @responsibility = @plan.responsibilities.new
    @responsibility.created_by = current_user.id
    @title = "New responsibility: #{@job.job_title}"
  end
  
  def create
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @responsibility = @plan.responsibilities.new(params[:responsibility])
    if @responsibility.save
      flash[:success] = "Responsibility added - now set goal(s)."
      redirect_to @responsibility
    else
      @title = "New responsibility: #{@job.job_title}"
      render 'new'
    end
  end
  
  def edit
    @responsibility = Responsibility.find(params[:id])
    @title = "Edit responsibility"
    @job = Job.find(session[:jobid])
  end

  def update
    @responsibility = Responsibility.find(params[:id])
    if params[:responsibility][:removed] == true
    
    else
      if @responsibility.update_attributes(params[:responsibility])
        @responsibility.update_attribute(:updated_by, current_user.id)
        flash[:success] = "Successfully updated."
        redirect_to @responsibility
      else
        @title = "Edit responsibility"
        @job = Job.find(session[:jobid])
        render 'edit'
      end 
    end
  end
  
  def destroy
    @responsibility = Responsibility.find(params[:id])
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    #Add condition to hide not delete if previous used in appraisal
    @responsibility.destroy
    flash[:success] = "Responsibility successfully deleted."
    redirect_to plan_responsibilities_path(@plan)
  end
  
end
