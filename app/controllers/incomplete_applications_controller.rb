class IncompleteApplicationsController < ApplicationController

  def index
    @user = current_user
    @applications = Application.where("user_id = ? and next_action = ? and submitted = ?", @user, 2, false).order("created_at DESC").paginate(:page => params[:page]) 
    @title = "Incomplete applications"
  end
  
  def destroy
    @application = Application.find(params[:id])  
    @application.destroy
    flash[:success] = "Removed incomplete application for vacancy ##{@application.vacancy.id} - #{@application.vacancy.headline}."
    redirect_to incomplete_applications_path
  end

end
