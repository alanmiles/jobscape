class AddValuesToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :mission, :text
    add_column :businesses, :values, :text
  end

  def self.down
    remove_column :businesses, :values
    remove_column :businesses, :mission
  end
end
