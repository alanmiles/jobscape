class ResponsibilitiesController < ApplicationController
  before_filter :authenticate
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @business = Business.find(@job.business_id)
    @responsibilities = @plan.responsibilities.find(:all,
         :conditions => ["responsibilities.removed = ?", false],
         :order => "responsibilities.rating DESC")
    @title = "Responsibilities"
    session[:responid] = nil
    clear_return_to
    store_location
  end
  
  def new
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    
    if @plan.max_responsibilities?
      flash[:notice] = "Sorry, you're only allowed 20 responsibilities"
      @title = "Responsibilities"
      redirect_to plan_responsibilities_path(@plan)
    else
      @responsibility = @plan.responsibilities.new
      @responsibility.created_by = current_user.id
      @title = "New responsibility"
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
          flash[:notice] = "You've now set the maximum number of responsibilities for the job. Now add up to 3 goals, and then set the rating." 
        else
          flash[:success] = "Responsibility added - #{@plan.count_responsibilities} in total so far.  Now add up to 3 goals, and then set the rating."
        end
        redirect_to responsibility_goals_path(@responsibility)
      else
        @title = "New responsibility"
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
    @plan = Plan.find(@responsibility.plan_id)
    if @responsibility.update_attributes(params[:responsibility])
      @responsibility.update_attribute(:updated_by, current_user.id)
      flash[:success] = "Responsibility successfully updated."
      redirect_back_or(plan_responsibilities_path(@plan))
    else
      @title = "Edit responsibility"
      @job = Job.find(session[:jobid])
      @characters_left = 140 - @responsibility.definition.length
      render 'edit'
    end 
  end
  
  def destroy
    @responsibility = Responsibility.find(params[:id])
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    if @responsibility.used?
      @responsibility.update_attributes(:removed => true, :removal_date => Date.today)
      flash[:success] = "Responsibility now hidden and archived - #{@plan.count_responsibilities} now listed."
    else
      @responsibility.destroy
      flash[:success] = "Responsibility successfully deleted - #{@plan.count_responsibilities} now listed."
    end
    redirect_to plan_responsibilities_path(@plan)
  end
  
end
