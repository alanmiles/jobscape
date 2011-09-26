# == Schema Information
#
# Table name: outlines
#
#  id         :integer         not null, primary key
#  job_id     :integer
#  role       :text            default("Your role is to ")
#  qualities  :text            default("To do this job well, you need ")
#  importance :text            default("The job is important to the organization because ")
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Outline do
  pending "add some examples to (or delete) #{__FILE__}"
end
