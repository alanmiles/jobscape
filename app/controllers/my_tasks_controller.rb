class MyTasksController < ApplicationController
  
  
  def index
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @placement = Placement.find_by_user_id_and_job_id(@user, @job)
    @tasks = @placement.tasks.order("tasks.task_date DESC").paginate(:page => params[:page])
    @title = "Your daily tasks"
  end

  def new
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @placement = Placement.find_by_user_id_and_job_id(@user, @job)
    @task = Task.new
    @task.placement_id = @placement.id
    @characters_left = 140
    @title = "Add a task"
  end
  
  def create
    @task = Task.new(params[:task])
    if @task.save
      @date = @task.task_date.strftime("%a %b %d")
      flash[:success] = "New task for #{@date} successfully added." 
      redirect_to my_tasks_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @job = @user.current_job(@business)
      @placement = Placement.find_by_user_id_and_job_id(@user, @job)
      @task.placement_id = @placement.id
      @characters_left = 140 - @task.task.length
      @title = "Add a task"
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @placement = Placement.find_by_user_id_and_job_id(@user, @job)
    @characters_left = 140 - @task.task.length
    @title = "Edit task"
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      @date = @task.task_date.strftime("%a %b %d")
      flash[:success] = "Task for #{@date} successfully updated." 
      redirect_to my_tasks_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @job = @user.current_job(@business)
      @placement = Placement.find_by_user_id_and_job_id(@user, @job)
      @characters_left = 140 - @task.task.length
      @title = "Edit task"
      render 'edit'
    
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @date = @task.task_date.strftime("%a %b %d")
    @task.destroy
    flash[:success] = "Task for #{@date} successfully removed." 
    redirect_to :back
  end

end
