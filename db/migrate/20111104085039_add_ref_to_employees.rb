class AddRefToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :ref_no, :integer
    add_column :employees, :left, :boolean, :default => false
  end

  def self.down
    remove_column :employees, :ref_no
    remove_column :employees, :left
  end
end
