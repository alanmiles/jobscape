class CurrentVacanciesController < ApplicationController
  
  def index
    @title = "Current vacancies"
    @vacancies = Vacancy.all_current.paginate(:page => params[:page]) 
    @details_link = true
    store_location
  end

end
