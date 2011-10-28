class CreateReviewgoals < ActiveRecord::Migration
  def self.up
    create_table :reviewgoals do |t|
      t.integer :reviewresponsibility_id
      t.integer :goal_id
      t.boolean :achieved, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :reviewgoals
  end
end
