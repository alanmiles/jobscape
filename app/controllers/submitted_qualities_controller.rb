class SubmittedQualitiesController < ApplicationController
  
  before_filter :authenticate
  before_filter :admin_user, :only => :index
  before_filter :check_status, :only => [:show, :edit, :update]
  before_filter :ownership, :only => [:show, :edit, :update]
    
  def index
    @title = "New attribute submissions"
    @qualities = Quality.new_list.paginate(:page => params[:page])
  end

  def new
    @title = "Attribute suggestion"
    @quality = Quality.new
    @quality.created_by = current_user.id
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job)
    @characters_left = 25
  end
  
  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      flash[:success] = "#{@quality.quality} added. Now improve the 5 PAMs."
      redirect_to submitted_quality_path(@quality)
    else
      @title = "New attribute submissions"
      @job = Job.find(session[:jobid])
      @plan = Plan.find_by_job_id(@job)
      @quality.created_by = current_user.id
      @characters_left = 25 - @quality.quality.length
      render 'new'
    end
  end
  
  def show
    @quality = Quality.find(params[:id])
    @title = "Attribute submission: #{@quality.quality}"
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job)
    @pams = @quality.pams.all
  end
  
  def edit
    @quality = Quality.find(params[:id])
    @title = "Edit attribute submission"
    @quality.updated_by = current_user.id
    @characters_left = 25 - @quality.quality.length
  end
  
  def update
    @quality = Quality.find(params[:id])
    @new_title = params[:quality][:quality]
    if @quality.update_attributes(params[:quality])
      @quality.update_attribute(:updated_by, current_user.id)
      flash[:success] = "'#{@new_title}' updated."
      redirect_to submitted_quality_path(@quality)
    else
      @title = "Edit attribute submission"
      @quality.updated_by = current_user.id
      @characters_left = 25 - @quality.quality.length
      render 'edit'
    end
    
  end
  
  def destroy
    @submission = Quality.find(params[:id]).destroy
    flash[:success] = "'#{@submission.quality}' and all associated PAMs removed."
    redirect_to submitted_qualities_path
  end
  
  private
  
    def check_status
      @quality = Quality.find(params[:id])
      if @quality.approved?
        redirect_to(root_path, 
          :notice => "Illegal procedure. You may have tried to edit an attribute that's already been approved.")
      elsif @quality.removed?
        redirect_to(root_path, 
          :notice => "Illegal procedure. You may have tried to edit an attribute that's already been rejected.")
      end
    end
    
    def ownership
      @quality = Quality.find(params[:id])
      unless @quality.created_by == current_user.id
        redirect_to(root_path, 
          :notice => "Illegal procedure. You tried to access an attribute that's private to another user.")
      end 
    end  
end
