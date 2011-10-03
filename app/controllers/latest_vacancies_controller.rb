class LatestVacanciesController < ApplicationController
  
  def index
    @vacancies = Vacancy.latest
    @title = "Latest vacancies"
    @details_link = true
  end
  
  def show
    @vacancy = Vacancy.find(params[:id])
    @title = "Vacancy details"
    @details_link = false 
    @job = Job.find(@vacancy.job_id)
    @outline = Outline.find_by_job_id(@job.id)
    @plan = Plan.find_by_job_id(@job.id)
    @responsibilities = @plan.top_five_responsibilities
    @qualities = @plan.top_five_attributes
    @requirements = @plan.top_five_requirements
  end

end
