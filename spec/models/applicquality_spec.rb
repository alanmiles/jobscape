# == Schema Information
#
# Table name: applicqualities
#
#  id              :integer         not null, primary key
#  application_id  :integer
#  quality_id      :integer
#  position        :integer
#  applicant_score :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Applicquality do
  pending "add some examples to (or delete) #{__FILE__}"
end
