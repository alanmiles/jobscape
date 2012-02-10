module VacanciesHelper

  def vacant_position
    if @vacancy.quantity == 1
      @vacancy.job.occupation.name
    else
      "#{@vacancy.quantity} #{@vacancy.job.occupation.name.pluralize}" 
    end
  end
  
end
