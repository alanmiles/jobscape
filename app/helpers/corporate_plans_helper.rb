module CorporatePlansHelper

  def mission_statement
    if @business.mission.nil? || @business.mission.empty?
      return "Not set."
    else
      @business.mission    
    end
  end
  
  def values_statement
    if @business.values.nil? || @business.values.empty? 
      return "Not set."
    else
      @business.values    
    end
  end
end
