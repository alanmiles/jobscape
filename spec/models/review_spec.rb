# == Schema Information
#
# Table name: reviews
#
#  id                        :integer         not null, primary key
#  reviewee_id               :integer
#  reviewer_id               :integer
#  reviewer_name             :string(255)
#  reviewer_email            :string(255)
#  secret_code               :string(255)
#  job_id                    :integer
#  responsibilities_score    :integer         default(0)
#  attributes_score          :integer         default(0)
#  achievements              :string(255)
#  problems                  :string(255)
#  observations              :string(255)
#  change_responsibilities   :string(255)
#  change_goals              :string(255)
#  change_attributes         :string(255)
#  plan                      :string(255)
#  responsibilities_complete :boolean         default(FALSE)
#  qualities_complete        :boolean         default(FALSE)
#  comments_complete         :boolean         default(FALSE)
#  completed                 :boolean         default(FALSE)
#  completion_date           :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  placement_id              :integer
#  review_type               :integer         default(1)
#

require 'spec_helper'

describe Review do
  pending "add some examples to (or delete) #{__FILE__}"
end
