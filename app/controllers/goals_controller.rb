class GoalsController < ApplicationController
  
  before_filter :authenticate
  
  def new
    @responsibility = Responsibility.find(session[:responid])
    @job = Job.find(session[:jobid])
    if @responsibility.maximum_goals?
      flash[:notice] = "Sorry, you can only have 3 goals for each responsibility"
      @title = "Responsibility for #{@job.job_title}"
      redirect_to @responsibility
    else
      @goal = @responsibility.goals.new 
      @goal.created_by = current_user.id
      @title = "Set a goal"
      @characters_left = 140
    end
  end
  
  def create
    @responsibility = Responsibility.find(session[:responid])
    @goal = @responsibility.goals.new(params[:goal])
    @job = Job.find(session[:jobid])
    if @responsibility.maximum_goals?
      flash[:notice] = "Sorry, you can only have 3 goals for each responsibility"
      @title = "Responsibility for #{@job.job_title}"
      redirect_to @responsibility
    else
      #@goal = @responsibility.goals.new(params[:goal])
      if @goal.save
        if @responsibility.count_current_goals == 3
          flash[:notice] = "You've now set all three goals for the responsibility"
        else
          flash[:success] = "Goal successfully added."
        end
        redirect_to @responsibility
      else
        @title = "Set a goal"
        @goal.created_by = current_user.id
        @characters_left = 140 - @goal.objective.length
        render 'new'
      end
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    @title = "Edit goal"
    @responsibility = Responsibility.find(@goal.responsibility_id)
    @job = Job.find(session[:jobid])
    @characters_left = 140 - @goal.objective.length
  end
  
  def update
    @goal = Goal.find(params[:id])
    @responsibility = Responsibility.find(session[:responid])
    if params[:goal][:removed] == true
    
    else
      if @goal.update_attributes(params[:goal])
        @goal.update_attribute(:updated_by, current_user.id)
        flash[:success] = "Goal successfully updated."
        redirect_to @responsibility
      else
        @title = "Edit goal"
        @job = Job.find(session[:jobid])
        @characters_left = 140 - @goal.objective.length
        render 'edit'
      end 
    end
  end
  
  def destroy
    @goal = Goal.find(params[:id])
    @responsibility = Responsibility.find(@goal.responsibility_id)
    #Add condition to hide not delete if previously used in appraisal
    @goal.destroy
    flash[:success] = "Goal successfully deleted."
    redirect_to @responsibility
  end
  
end
