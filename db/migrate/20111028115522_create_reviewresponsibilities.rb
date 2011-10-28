class CreateReviewresponsibilities < ActiveRecord::Migration
  def self.up
    create_table :reviewresponsibilities do |t|
      t.integer :review_id
      t.integer :responsibility_id
      t.integer :position
      t.integer :rating_value
      t.integer :total_goals
      t.integer :achieved_goals, :default => 0
      t.float :achievement_score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :reviewresponsibilities
  end
end
