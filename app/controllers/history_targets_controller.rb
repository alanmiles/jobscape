class HistoryTargetsController < ApplicationController
  
  def index
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @placement = Placement.find_by_user_id_and_job_id(@user, @job)
    @targets = @placement.history_targets.paginate(:page => params[:page])
    @title = "Your targets - completed and cancelled"
  end

end
