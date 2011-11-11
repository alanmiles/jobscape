class AddInactiveToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :inactive, :boolean, :default => false
  end

  def self.down
    remove_column :jobs, :inactive
  end
end
