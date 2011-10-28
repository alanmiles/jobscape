# == Schema Information
#
# Table name: reviewgoals
#
#  id                      :integer         not null, primary key
#  reviewresponsibility_id :integer
#  goal_id                 :integer
#  achieved                :boolean         default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#

require 'spec_helper'

describe Reviewgoal do
  pending "add some examples to (or delete) #{__FILE__}"
end
