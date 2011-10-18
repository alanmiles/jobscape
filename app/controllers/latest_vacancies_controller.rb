class LatestVacanciesController < ApplicationController
  
  def index
    @vacancies = Vacancy.latest
    @title = "Latest vacancies"
    @details_link = true
  end

end
