class ResponsibilitiesController < ApplicationController
  before_filter :authenticate
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @responsibilities = @plan.responsibilities.find(:all,
         :conditions => ["responsibilities.removed = ?", false],
         :order => "responsibilities.rating DESC")
    @title = "Responsibilities: #{@job.job_title}"
    session[:responid] = nil
  end

  def show
    @responsibility = Responsibility.find(params[:id])
    session[:responid] = @responsibility.id
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @title = "Responsibility for #{@job.job_title}"
    @goals = @responsibility.goals.all
    @evaluation = Evaluation.find_by_responsibility_id(@responsibility.id)
  end
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    
    if @plan.max_responsibilities?
      flash[:notice] = "Sorry, you're only allowed 20 responsibilities"
      @title = "Responsibilities: #{@job.job_title}"
      redirect_to plan_responsibilities_path(@plan)
    else
      @responsibility = @plan.responsibilities.new
      @responsibility.created_by = current_user.id
      @title = "New responsibility: #{@job.job_title}"
      @characters_left = 140
    end
  end
  
  def create
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    if @plan.max_responsibilities?
      flash[:notice] = "Sorry, you're only allowed 20 responsibilities"
      @title = "Responsibilities: #{@job.job_title}"
      redirect_to plan_responsibilities_path(@plan)
    else
      @responsibility = @plan.responsibilities.new(params[:responsibility])
      if @responsibility.save
        if @plan.count_responsibilities == 20
          flash[:notice] = "You've now set the maximum number of responsibilities for the job" 
        else
          flash[:success] = "Responsibility added - #{@plan.count_responsibilities} in total so far.  Now add up to 3 goals, and then set the Rating."
        end
        redirect_to @responsibility
      else
        @title = "New responsibility: #{@job.job_title}"
        @responsibility.created_by = current_user.id
        @characters_left = 140 - @responsibility.definition.length
        @job = Job.find(session[:jobid])
        @plan = Plan.find_by_job_id(@job.id)
        render 'new'
      end
    end
  end
  
  def edit
    @responsibility = Responsibility.find(params[:id])
    @title = "Edit responsibility"
    @job = Job.find(session[:jobid])
    @characters_left = 140 - @responsibility.definition.length
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
        @characters_left = 140 - @responsibility.definition.length
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
    flash[:success] = "Responsibility successfully deleted - #{@plan.count_responsibilities} now listed."
    redirect_to plan_responsibilities_path(@plan)
  end
  
end
