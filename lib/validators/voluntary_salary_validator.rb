class VoluntarySalaryValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    if value == true
      record.errors[attribute] << "can't be correct if you've set any kind of salary or hourly rate"  
    end  
  end  
end  
