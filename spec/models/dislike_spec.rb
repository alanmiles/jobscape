# == Schema Information
#
# Table name: dislikes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  dislike    :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Dislike do
  pending "add some examples to (or delete) #{__FILE__}"
end
