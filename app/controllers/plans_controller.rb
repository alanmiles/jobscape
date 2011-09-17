class PlansController < ApplicationController


  def show
    @business = Business.find(session[:biz])
    @plan = Plan.find(params[:id])
    @job = Job.find(@plan.job_id)
  end

end
