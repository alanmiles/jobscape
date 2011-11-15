class NotHiredValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    @business = Business.find(record.business_id)
    still_employed = @business.users.joins(:employees).where("users.email = ? and employees.left = ?", value, false).count
    was_employed = @business.users.joins(:employees).where("users.email = ? and employees.left = ?", value, true).count
    if still_employed > 0
      record.errors[attribute] << " belongs to someone who is already one of the business's employees"  
    elsif was_employed > 0
      record.errors[attribute] << " belongs to someone who is still listed as one of the business's former employees.  (Reactivate from 'Former Employees' instead."  
    end  
  end  
end  
