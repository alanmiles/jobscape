class AddReviewTypeToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :review_type, :integer, :default => 1
  end

  def self.down
    remove_column :reviews, :review_type
  end
end
