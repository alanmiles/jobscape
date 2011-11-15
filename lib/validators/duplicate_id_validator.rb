class DuplicateIdValidator < ActiveModel::EachValidator  
  def validate_each(record, attribute, value)  
    @business = Business.find(record.business_id)
    cnt = @business.employees.where("ref_no = ?", value).count
    if cnt > 0
      record.errors[attribute] << " has already been used in this business"  
    end  
  end  
end  
