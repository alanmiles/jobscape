class Officer::VacanciesController < ApplicationController
  
  
  def index
    @business = Business.find(session[:biz])
    @vacancies = @business.current_vacancies.paginate(:page => params[:page])
    @title = "Current vacancies"
  end
  
  def show
    @business = Business.find(session[:biz])
    @vacancy = Vacancy.find(params[:id])
    @title = "Vacancy details"
    @applications = @vacancy.all_completed_applications
  end
  
  def new
  
  
  end

end
