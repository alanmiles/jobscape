class AddRefToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :ref, :integer
    add_column :employees, :left, :boolean, :default => false
  end

  def self.down
    remove_column :employees, :ref
    remove_column :employees, :left
  end
end
