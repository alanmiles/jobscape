class GoalsController < ApplicationController
  
  before_filter :authenticate
  
  def new
    @responsibility = Responsibility.find(session[:responid])
    @goal = @responsibility.goals.new 
    @goal.created_by = current_user.id
    @title = "Set a goal"
    @job = Job.find(session[:jobid])
  end
  
  def create
    @responsibility = Responsibility.find(session[:responid])
    @goal = @responsibility.goals.new(params[:goal])
    if @goal.save
      flash[:success] = "Goal successfully added."
      redirect_to @responsibility
    else
      @title = "Set a goal"
      @job = Job.find(session[:jobid])
      @goal.created_by = current_user.id
      render 'new'
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    @title = "Edit goal"
    @responsibility = Responsibility.find(@goal.responsibility_id)
    @job = Job.find(session[:jobid])
  end
  
  def update
    @goal = Goal.find(params[:id])
    @responsibility = Responsibility.find(session[:responid])
    if params[:goal][:removed] == true
    
    else
      if @goal.update_attributes(params[:goal])
        @goal.update_attribute(:updated_by, current_user.id)
        flash[:success] = "Successfully updated."
        redirect_to @responsibility
      else
        @title = "Edit goal"
        @job = Job.find(session[:jobid])
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
