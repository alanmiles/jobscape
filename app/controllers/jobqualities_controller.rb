class JobqualitiesController < ApplicationController
  
  before_filter :authenticate
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @business = Business.find(session[:biz])
    @title = "Attributes"
    @jobqualities = @plan.jobqualities.order("jobqualities.position")
  end

  def sort
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @plan.jobqualities.each do |f|
      f.position = params["jobquality"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def show
    @jobquality = Jobquality.find(params[:id])
    @title = "Attribute + Grades"
    @quality = Quality.find(@jobquality.quality_id)
    @pams = @quality.pams
    @job = Job.find(session[:jobid])
  end
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @selected_qualities = @plan.jobqualities.order("jobqualities.position")
    store_location
    if @plan.max_attributes?
      flash[:notice] = "Sorry, you're only allowed 10 attributes. You'll need to delete an attribute before adding a new one."
      @title = "Attributes"
      redirect_to plan_jobqualities_path(@plan)
    else
      @jobquality = @plan.jobqualities.new
      @qualities = @plan.attributes_available
      @title = "Select attribute"
    end
  end

  def create
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    if @plan.max_attributes?
      flash[:notice] = "Sorry, you're only allowed 10 attributes"
      @title = "Attributes"
      redirect_to plan_jobqualities_path(@plan)
    else
      @jobquality = @plan.jobqualities.new(params[:jobquality])
      if @jobquality.save
        if @plan.count_attributes == 10
          flash[:notice] = "'#{@jobquality.quality.quality}' added.  You've now set all 10 attributes required for the A-Plan." 
        else
          flash[:success] = "'#{@jobquality.quality.quality}' added."
        end
        redirect_to plan_jobqualities_path(@plan)
      else
        @title = "Select attribute"
        @selected_qualities = @plan.jobqualities.order("jobqualities.position")
        @qualities = @plan.attributes_available
        render 'new'
      end
    end
  end
  
  def destroy
    @jobquality = Jobquality.find(params[:id])
    @plan = Plan.find(@jobquality.plan_id)
    @jobquality.destroy
    flash[:success] = "'#{@jobquality.quality.quality}' no longer listed for this job."
    redirect_to plan_jobqualities_path(@plan)
  end
end
