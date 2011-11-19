# == Schema Information
#
# Table name: tasks
#
#  id           :integer         not null, primary key
#  placement_id :integer
#  task         :string(255)
#  personal     :boolean         default(FALSE)
#  completed    :boolean         default(FALSE)
#  task_date    :date
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
