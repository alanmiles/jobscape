class AddPositionToJobqualities < ActiveRecord::Migration
  def self.up
    add_column :jobqualities, :position, :integer
  end

  def self.down
    remove_column :jobqualities, :position
  end
end
