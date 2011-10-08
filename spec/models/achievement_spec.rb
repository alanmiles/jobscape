# == Schema Information
#
# Table name: achievements
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  achievement :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Achievement do
  pending "add some examples to (or delete) #{__FILE__}"
end
