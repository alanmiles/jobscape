class AddSignedUpToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :signed_up, :boolean, :default => false
  end

  def self.down
    remove_column :invitations, :signed_up
  end
end
