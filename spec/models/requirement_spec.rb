# == Schema Information
#
# Table name: requirements
#
#  id          :integer         not null, primary key
#  plan_id     :integer
#  requirement :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Requirement do
  pending "add some examples to (or delete) #{__FILE__}"
end
