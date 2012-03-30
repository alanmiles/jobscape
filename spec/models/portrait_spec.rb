# == Schema Information
#
# Table name: portraits
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  worked_before :boolean         default(FALSE)
#  right_to_work :boolean         default(FALSE)
#  notes         :string(255)
#  public        :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  mail_address  :string(255)
#  home_phone    :string(255)
#  mobile        :string(255)
#

require 'spec_helper'

describe Portrait do
  pending "add some examples to (or delete) #{__FILE__}"
end
