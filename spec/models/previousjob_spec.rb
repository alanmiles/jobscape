# == Schema Information
#
# Table name: previousjobs
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  job        :string(255)
#  years      :integer         default(0)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Previousjob do
  pending "add some examples to (or delete) #{__FILE__}"
end
