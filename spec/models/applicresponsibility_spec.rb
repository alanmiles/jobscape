# == Schema Information
#
# Table name: applicresponsibilities
#
#  id                :integer         not null, primary key
#  application_id    :integer
#  responsibility_id :integer
#  position          :integer
#  applicant_score   :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Applicresponsibility do
  pending "add some examples to (or delete) #{__FILE__}"
end
