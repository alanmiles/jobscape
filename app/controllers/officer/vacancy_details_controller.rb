class Officer::VacancyDetailsController < ApplicationController
  
  before_filter :authenticate
  before_filter :correct_officer
    
  def show
    @vacancy = Vacancy.find(params[:id])
    @title = "Vacancy: full details"
    @details_link = false 
    @job = Job.find(@vacancy.job_id)
    @outline = Outline.find_by_job_id(@job.id)
    @plan = Plan.find_by_job_id(@job.id)
    @responsibilities = @plan.top_five_responsibilities
    @qualities = @plan.top_five_attributes
    @requirements = @plan.top_five_requirements
  end

end
