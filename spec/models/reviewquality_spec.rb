# == Schema Information
#
# Table name: reviewqualities
#
#  id             :integer         not null, primary key
#  review_id      :integer
#  quality_id     :integer
#  position       :integer
#  reviewer_score :integer         default(0)
#  adjusted_score :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Reviewquality do
  pending "add some examples to (or delete) #{__FILE__}"
end
