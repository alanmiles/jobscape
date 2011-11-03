# == Schema Information
#
# Table name: departments
#
#  id          :integer         not null, primary key
#  business_id :integer
#  name        :string(255)
#  manager_id  :integer
#  deputy_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Department do
  pending "add some examples to (or delete) #{__FILE__}"
end
