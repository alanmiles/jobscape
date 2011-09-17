class JobqualitiesController < ApplicationController
  
  before_filter :authenticate
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @title = "Attributes: #{@job.job_title}"
    @jobqualities = @plan.jobqualities.order(:position)
  end

  def sort
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @plan.jobqualities.each do |f|
      f.position = params["a-plan"].index(f.id.to_s)+1
      f.save
    end
  
  render :nothing => true  
  end  
  
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    if @plan.max_attributes?
      flash[:notice] = "Sorry, you're only allowed 10 attributes"
      @title = "Attributes: #{@job.job_title}"
      redirect_to plan_jobqualities_path(@plan)
    else
      @jobquality = @plan.jobqualities.new
      if @plan.jobqualities.count == 0
        @qualities = Quality.official_list
      else
        @qualities = Quality.official_list_excluding_taken(@plan.id)
      end
      @title = "New attribute: #{@job.job_title}"
    end
  end

  def create
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    if @plan.max_attributes?
      flash[:notice] = "Sorry, you're only allowed 10 attributes"
      @title = "Attributes: #{@job.job_title}"
      redirect_to plan_jobqualities_path(@plan)
    else
      @jobquality = @plan.jobqualities.new(params[:jobquality])
      if @jobquality.save
        if @plan.count_attributes == 10
          flash[:notice] = "You've now set the maximum number of attributes for the job" 
        else
          flash[:success] = "Attribute added."
        end
        redirect_to plan_jobqualities_path(@plan)
      else
        @title = "New attribute: #{@job.job_title}"
        @qualities = Quality.official_list_excluding_taken(@plan.id)
        render 'new'
      end
    end
  end
end
