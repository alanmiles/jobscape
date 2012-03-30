class AddContactsToPortraits < ActiveRecord::Migration
  def self.up
    add_column :portraits, :mail_address, :string
    add_column :portraits, :home_phone, :string
    add_column :portraits, :mobile, :string
  end

  def self.down
    remove_column :portraits, :mobile
    remove_column :portraits, :home_phone
    remove_column :portraits, :mail_address
  end
end
