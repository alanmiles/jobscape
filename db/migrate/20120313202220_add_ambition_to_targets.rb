class AddAmbitionToTargets < ActiveRecord::Migration
  def self.up
    add_column :targets, :ambition_id, :integer
  end

  def self.down
    remove_column :targets, :ambition_id
  end
end
