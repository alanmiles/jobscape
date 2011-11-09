class AddStaffNoToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :staff_no, :integer
  end

  def self.down
    remove_column :invitations, :staff_no
  end
end
