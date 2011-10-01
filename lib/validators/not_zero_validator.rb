class NotZeroValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    if value <= 0
      record.errors[attribute] << "cannot be zero or a negative number"  
    end  
  end  
end  
