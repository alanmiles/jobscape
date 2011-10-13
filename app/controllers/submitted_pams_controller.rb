class SubmittedPamsController < ApplicationController
  
  before_filter :authenticate
  before_filter :check_status
  before_filter :ownership
  before_filter :not_admin_user
  
  def edit
    @pam = Pam.find(params[:id])
    @title = "Edit PAM submission"
    @pam.updated_by = current_user.id
    @quality = Quality.find(@pam.quality_id)
    @pams = @quality.pams.all
    @characters_left = 255 - @pam.descriptor.length
  end
  
  def update
    @pam = Pam.find(params[:id])
    if @pam.update_attributes(params[:pam])
      flash[:success] = "Grade #{@pam.grade} updated."
      redirect_to submitted_quality_path(@pam.quality_id)
    else
      @title = "Edit PAM submission"
      @pam.updated_by = current_user.id
      @quality = Quality.find(@pam.quality_id)
      @pams = @quality.pams.all
      @characters_left = 255 - @pam.descriptor.length
      render 'edit'
    end
  
  end

  private
  
    def check_status
      @pam = Pam.find(params[:id])
      @quality = Quality.find(@pam.quality_id)
      if @quality.approved?
        redirect_to(root_path, 
          :notice => "Illegal procedure. You may have tried to access an attribute that's already been approved.")
      elsif @quality.removed?
        redirect_to(root_path, 
          :notice => "Illegal procedure. You may have tried to access an attribute that's already been rejected.")
      end
    end
    
    def ownership
      @pam = Pam.find(params[:id])
      @quality = Quality.find(@pam.quality_id)
      unless @quality.created_by == current_user.id
        redirect_to(root_path, 
          :notice => "Illegal procedure. You tried to access an attribute that's private to another user.")
      end 
    end  
end
