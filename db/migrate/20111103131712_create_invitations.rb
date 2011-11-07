class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :business_id
      t.string :name
      t.string :email
      t.string :security_code
      t.integer :inviter_id
      t.integer :invitee_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
