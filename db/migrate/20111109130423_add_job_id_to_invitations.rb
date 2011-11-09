class AddJobIdToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :job_id, :integer
  end

  def self.down
    remove_column :invitations, :job_id
  end
end
