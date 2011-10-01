# == Schema Information
#
# Table name: vacancies
#
#  id             :integer         not null, primary key
#  job_id         :integer
#  sector_id      :integer
#  quantity       :integer         default(1)
#  annual_salary  :integer
#  hourly_rate    :decimal(5, 2)
#  full_time      :boolean         default(TRUE)
#  voluntary      :boolean         default(FALSE)
#  close_date     :date
#  filled         :boolean         default(FALSE)
#  notes          :string(255)
#  contact_person :string(255)
#  contact_email  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Vacancy do
  pending "add some examples to (or delete) #{__FILE__}"
end
