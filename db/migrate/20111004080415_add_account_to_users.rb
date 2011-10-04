class AddAccountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account, :integer, :default => 1
    add_column :users, :terms, :boolean, :default => false
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
  end

  def self.down
    remove_column :users, :account
    remove_column :users, :terms
    remove_column :users, :latitude
    remove_column :users, :longitude
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :country
  end
end
