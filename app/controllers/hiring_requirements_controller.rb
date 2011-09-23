class HiringRequirementsController < ApplicationController
  
  
  def index
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @qualifications = @plan.qualifications.order("qualifications.position")
    @title = "Hiring Requirements"
  end

end
