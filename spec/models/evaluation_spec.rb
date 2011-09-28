# == Schema Information
#
# Table name: evaluations
#
#  id                :integer         not null, primary key
#  responsibility_id :integer
#  profits           :integer         default(0)
#  customers         :integer         default(0)
#  staff             :integer         default(0)
#  processes         :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Evaluation do
  pending "add some examples to (or delete) #{__FILE__}"
end
