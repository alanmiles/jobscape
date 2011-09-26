class PlansController < ApplicationController


  def show
    @business = Business.find(session[:biz])
    @plan = Plan.find(params[:id])
    @job = Job.find(@plan.job_id)
    @outline = Outline.find_by_job_id(@job.id)
  end

end
