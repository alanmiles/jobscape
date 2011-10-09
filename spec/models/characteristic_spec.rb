# == Schema Information
#
# Table name: characteristics
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  characteristic :string(255)
#  position       :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Characteristic do
  pending "add some examples to (or delete) #{__FILE__}"
end
