class AplansController < ApplicationController
  
  def show
    @plan = Plan.find(params[:id])
    @job = Job.find(session[:jobid])
    @outline = Outline.find_by_job_id(@job.id)
    @business = Business.find(@job.business_id)
    @responsibilities = @plan.current_responsibilities
    @jobqualities = @plan.jobqualities.order("jobqualities.position")
    @requirements = @plan.requirements.order("requirements.position")
    if current_user.account == 3
      @title = "A-Plan"
    else
      @title = "Your A-Plan"
    end
  end

end
