class SalaryDoubleValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    if value != nil
      record.errors[attribute] << "should not be set as well as an hourly rate.  Clear the value in one of them."  
    end  
  end  
end  
