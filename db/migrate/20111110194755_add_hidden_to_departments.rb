class AddHiddenToDepartments < ActiveRecord::Migration
  def self.up
    add_column :departments, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :departments, :hidden
  end
end
