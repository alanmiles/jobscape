# == Schema Information
#
# Table name: targets
#
#  id           :integer         not null, primary key
#  placement_id :integer
#  target       :string(255)
#  target_date  :date
#  achieved     :boolean         default(FALSE)
#  cancelled    :boolean         default(FALSE)
#  note         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  ambition_id  :integer
#

require 'spec_helper'

describe Target do
  pending "add some examples to (or delete) #{__FILE__}"
end
