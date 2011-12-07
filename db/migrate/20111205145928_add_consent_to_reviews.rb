class AddConsentToReviews < ActiveRecord::Migration
  
  def self.up
    add_column :reviews, :consent, :boolean
  end

  def self.down
    remove_column :reviews, :consent
  end
end
