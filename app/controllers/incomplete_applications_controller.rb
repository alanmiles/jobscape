class IncompleteApplicationsController < ApplicationController

  def index
    @user = current_user
    @applications = Application.joins(:vacancy).where("user_id = ? and next_action = ? and 
      submitted = ? and vacancies.close_date >= ?", @user, 2, false, Date.today).order("updated_at DESC").paginate(:page => params[:page]) 
    @title = "Incomplete applications"
    store_location
  end
  
  def destroy
    @application = Application.find(params[:id])  
    @application.destroy
    flash[:success] = "Removed incomplete application for vacancy ##{@application.vacancy.id} - #{@application.vacancy.headline}."
    #redirect_to incomplete_applications_path
    redirect_to :back
  end

end
