# == Schema Information
#
# Table name: placements
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  job_id     :integer
#  current    :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Placement do
  pending "add some examples to (or delete) #{__FILE__}"
end
