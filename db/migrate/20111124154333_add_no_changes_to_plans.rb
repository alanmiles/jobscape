class AddNoChangesToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :no_changes, :boolean, :default => false
  end

  def self.down
    remove_column :plans, :no_changes
  end
end
