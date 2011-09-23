# == Schema Information
#
# Table name: qualifications
#
#  id            :integer         not null, primary key
#  plan_id       :integer
#  qualification :string(255)
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Qualification do
  pending "add some examples to (or delete) #{__FILE__}"
end
