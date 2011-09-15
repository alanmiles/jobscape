class PamsController < ApplicationController
  
  before_filter :authenticate
  
  def edit
    @pam = Pam.find(params[:id])
    @title = "Edit PAM"
    @pam.updated_by = current_user.id
    @quality = Quality.find(@pam.quality_id)
    @pams = @quality.pams.all
  end
  
  def update
    @pam = Pam.find(params[:id])
    if @pam.update_attributes(params[:pam])
      flash[:success] = "Grade #{@pam.grade} updated."
      redirect_to quality_path(@pam.quality_id)
    else
      @title = "Edit PAM"
      @pam.updated_by = current_user.id
      @quality = Quality.find(@pam.quality_id)
      @pams = @quality.pams.all
      render 'edit'
    end
  
  end

end
