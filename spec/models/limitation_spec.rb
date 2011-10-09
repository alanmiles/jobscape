# == Schema Information
#
# Table name: limitations
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  limitation :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Limitation do
  pending "add some examples to (or delete) #{__FILE__}"
end
