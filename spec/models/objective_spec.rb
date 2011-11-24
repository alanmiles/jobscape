# == Schema Information
#
# Table name: objectives
#
#  id          :integer         not null, primary key
#  business_id :integer
#  objective   :string(255)
#  focus       :integer
#  measurement :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Objective do
  pending "add some examples to (or delete) #{__FILE__}"
end
