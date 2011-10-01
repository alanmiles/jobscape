class VoluntaryCheckValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    if value == false || value == nil
      record.errors[attribute] << "should be checked unless you enter either an annual salary or an hourly rate."  
    end  
  end  
end  
