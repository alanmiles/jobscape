require 'spec_helper'

describe Application do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: applications
#
#  id                     :integer         not null, primary key
#  vacancy_id             :integer
#  user_id                :integer
#  next_action            :integer         default(0)
#  submitted              :boolean         default(FALSE)
#  submission_date        :datetime
#  requirements_score     :integer         default(0)
#  qualities_score        :integer         default(0)
#  portrait_score         :integer         default(0)
#  employer_shortlist     :boolean         default(FALSE)
#  created_at             :datetime
#  updated_at             :datetime
#  personal_statement     :string(255)
#  responsibilities_score :integer         default(0)
#

