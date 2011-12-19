class AddContributionToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :contribution, :integer
  end

  def self.down
    remove_column :reviews, :contribution
  end
end
