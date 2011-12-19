class AddSeenByRevieweeToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :seen_by_reviewee, :boolean, :default => true
  end

  def self.down
    remove_column :reviews, :seen_by_reviewee
  end
end
