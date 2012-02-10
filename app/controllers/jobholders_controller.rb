class JobholdersController < ApplicationController
  
  def index
    @job = Job.find(session[:jobid])
    @business = Business.find(@job.business_id)
    @jobholders = @job.active_users
    @title = "Jobholders"
    store_location
  end

end
