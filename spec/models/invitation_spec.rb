# == Schema Information
#
# Table name: invitations
#
#  id            :integer         not null, primary key
#  business_id   :integer
#  name          :string(255)
#  email         :string(255)
#  security_code :string(255)
#  inviter_id    :integer
#  invitee_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  signed_up     :boolean         default(FALSE)
#  staff_no      :integer
#  job_id        :integer
#

require 'spec_helper'

describe Invitation do
  pending "add some examples to (or delete) #{__FILE__}"
end
