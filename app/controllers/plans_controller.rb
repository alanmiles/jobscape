class PlansController < ApplicationController
  
  def show
    @plan = Plan.find(params[:id])
    @job = Job.find(@plan.job_id)
  end

end
