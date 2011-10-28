class CreateReviewqualities < ActiveRecord::Migration
  def self.up
    create_table :reviewqualities do |t|
      t.integer :review_id
      t.integer :quality_id
      t.integer :position
      t.integer :reviewer_score, :default => 0
      t.integer :adjusted_score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :reviewqualities
  end
end
