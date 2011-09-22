class AttributeSubmissionsController < ApplicationController
  
  before_filter :admin_user
  
  def index
    @title = "New attribute submissions"
    @qualities = Quality.new_list
    @rejections = Quality.all_rejected
  end

  def edit
    @quality = Quality.find(params[:id])
    @title = "Approve attribute submission"
    @pams = @quality.pams
  end
  
  def update
    @quality = Quality.find(params[:id])
    @rejected = params[:quality][:removed]
    if params[:quality][:approved] == params[:quality][:removed]
      flash.now[:error] = "Please check just ONE of the boxes"
      @title = "Approve attribute submission"
      @pams = @quality.pams
      render 'edit'
    else
      if @quality.update_attributes(params[:quality])
        if @rejected == "1"
      	  @quality.update_attribute(:removal_date, Date.today)
          flash[:success] = "'#{@quality.quality}' rejected."
          redirect_to attribute_rejections_path
        else
          flash[:success] = "'#{@quality.quality}' approved."
          redirect_to qualities_path
        end  
      else
        @title = "Approve attribute submission"
        @pams = @quality.pams
        render 'edit'
      end
    end
  end
  
  def show
    @quality = Quality.find(params[:id])
    @title = "Submission: #{@quality.quality}"
    @pams = @quality.pams
  end
  
  def destroy
    @submission = Quality.find(params[:id]).destroy
    flash[:success] = "'#{@submission.quality}' and all associated PAMs removed."
    if @submission.rejected?
      redirect_to attribute_rejections_path
    else
      redirect_to attribute_submissions_path
    end
  end
end
