# == Schema Information
#
# Table name: reviewresponsibilities
#
#  id                :integer         not null, primary key
#  review_id         :integer
#  responsibility_id :integer
#  position          :integer
#  rating_value      :integer
#  total_goals       :integer
#  achieved_goals    :integer         default(0)
#  achievement_score :float           default(0.0)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Reviewresponsibility do
  pending "add some examples to (or delete) #{__FILE__}"
end
