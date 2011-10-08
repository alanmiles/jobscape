class CurrentVacanciesController < ApplicationController
  
  def index
    @title = "Current vacancies"
    @vacancies = Vacancy.all_current.paginate(:page => params[:page]) 
  end

end
