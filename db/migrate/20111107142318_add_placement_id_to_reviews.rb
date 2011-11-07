class AddPlacementIdToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :placement_id, :integer
  end

  def self.down
    remove_column :reviews, :placement_id
  end
end
