class PamsController < ApplicationController
  
  before_filter :authenticate
  
  def edit
    @pam = Pam.find(params[:id])
    @title = "Edit PAM"
    @pam.updated_by = current_user.id
    @quality = Quality.find(@pam.quality_id)
    @pams = @quality.pams.order("pams.grade")
  end
  
  def update
    @pam = Pam.find(params[:id])
    if @pam.update_attributes(params[:pam])
      flash[:success] = "Grade #{@pam.grade} updated."
      if @pam.quality.submitted? | @pam.quality.rejected?
        redirect_to attribute_submission_path(@pam.quality_id)
      else
        redirect_to quality_path(@pam.quality_id)
      end
    else
      @title = "Edit PAM"
      @pam.updated_by = current_user.id
      @quality = Quality.find(@pam.quality_id)
      @pams = @quality.pams.all
      render 'edit'
    end
  
  end

end
