class PlacementsController < ApplicationController
  
  before_filter :authenticate
  before_filter :officer_user
  before_filter :started_business_session
  before_filter :correct_business
  
  def new
    @user = User.find(params[:user_id])
    @placement = @user.placements.build
    @business = Business.find(session[:biz])
    @jobs = @business.available_jobs
    @title = "New job"
  end
  
  def create
    @user = User.find(params[:user_id])
    @business = Business.find(session[:biz])
    @placement = @user.placements.new(params[:placement])
    if @placement.save
      @user.deactivate_old_placements(@placement, @business)
      flash[:success] = "Successfully reassigned to #{@placement.job_dept}"
      redirect_to officer_user_path(@user)
    else
      @title = "New job"
      @business = Business.find(session[:biz])
      @jobs = @business.available_jobs
      render 'new'
    end
  end
  
  def edit
    @placement = Placement.find(params[:id])
    @user = User.find(@placement.user_id)
    @job = Job.find(@placement.job_id)
    if @placement.current
      @title = "Edit start-date for current job"
    else
      @title = "Edit start-date for previous job"
    end
  end
  
  def update
    @placement = Placement.find(params[:id])
    @user = User.find(@placement.user_id)
    @job = Job.find(@placement.job_id)
    if @placement.update_attributes(params[:placement])
      flash[:success] = "Start-date as #{@job.job_title} updated"
      redirect_to officer_user_path(@user)
    else
      if @placement.current
        @title = "Edit start-date for current job"
      else
        @title = "Edit start-date for previous job"
      end
      render 'edit'
    end
  end
  
  def destroy
    @placement = Placement.find(params[:id])
    @user = User.find(@placement.user_id)
    @job = Job.find(@placement.job_id)
    if @user.has_formal_reviews?(@job)
      flash[:notice] = "There were formal reviews for this job, so you're not allowed to delete it."
      redirect_to officer_user_path(@user)
    else
      @placement.destroy
      flash[:success] = "#{@job.job_title} successfully removed."
      redirect_to officer_user_path(@user)
    end
  end
 
end
