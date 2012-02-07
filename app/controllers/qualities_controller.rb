class QualitiesController < ApplicationController
  
  before_filter :authenticate, :except => :index
  
  def index
    @title = "Personal Attributes"
    @qualities = Quality.official_list
    @submissions = Quality.new_submissions
    @rejections = Quality.all_rejected
  end

  def new
    @title = "New attribute"
    @quality = Quality.new
    @quality.created_by = current_user.id
    @characters_left = 25
  end
  
  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      if current_user.admin?
        @quality.update_attributes(:approved => true,
                 :seen => true)
      end
      flash[:success] = "'#{@quality.quality}' added. Now set the 5 PAMs."
      redirect_to @quality
    else
      @title = "New attribute"
      @characters_left = 25 - @quality.quality.length
      @quality.created_by = current_user.id
      render 'new'
    end
  end
  
  def show
    @quality = Quality.find(params[:id])
    @title = "Attribute grades"
    @pams = @quality.pams.order("pams.grade")
  end
  
  def edit
    @quality = Quality.find(params[:id])
    @title = "Edit attribute"
    @characters_left = 25 - @quality.quality.length
  end
  
  def update
    @quality = Quality.find(params[:id])
    @new_title = params[:quality][:quality]
    if @quality.update_attributes(params[:quality])
      @quality.update_attribute(:updated_by, current_user.id)
      flash[:success] = "'#{@new_title}' updated."
      if @quality.submitted? | @quality.rejected?
        redirect_to attribute_submission_path(@quality)
      else
        redirect_to qualities_path
      end
    else
      @title = "Edit attribute"
      @characters_left = 25 - @quality.quality.length
      render 'edit'
    end
  end

  def destroy
    ##TO BE UPDATED - If in use in employee history, should not be deletable
    
    @quality = Quality.find(params[:id])
    if Jobquality.attribute_used?(@quality)
      flash[:error] = "Illegal procedure. This attribute is in use and cannot be removed."
      redirect_to root_path
    else
      @quality.destroy
      flash[:success] = "'#{@quality.quality}' successfully deleted."
      redirect_to qualities_path
    end
  
  end
end
