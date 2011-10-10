# == Schema Information
#
# Table name: references
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  name            :string(255)
#  relationship    :integer         default(4)
#  role            :string(255)
#  location        :string(255)
#  address         :string(255)
#  phone           :string(255)
#  email           :string(255)
#  portrait_rating :integer         default(7)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Reference do
  pending "add some examples to (or delete) #{__FILE__}"
end
