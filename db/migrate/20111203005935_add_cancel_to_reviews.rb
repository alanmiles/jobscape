class AddCancelToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :cancel, :boolean, :default => false
    add_column :reviews, :cancellation_reason, :string
  end

  def self.down
    remove_column :reviews, :cancellation_reason
    remove_column :reviews, :cancel
  end
end
