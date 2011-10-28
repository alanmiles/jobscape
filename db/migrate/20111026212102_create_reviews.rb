class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :reviewee_id
      t.integer :reviewer_id
      t.string :reviewer_name
      t.string :reviewer_email
      t.string :secret_code
      t.integer :job_id
      t.integer :responsibilities_score, :default => 0
      t.integer :attributes_score, :default => 0
      t.string :achievements
      t.string :problems
      t.string :observations
      t.string :change_responsibilities
      t.string :change_goals
      t.string :change_attributes
      t.string :plan
      t.boolean :completed, :default => false
      t.datetime :completion_date

      t.timestamps
    end
    add_index :reviews, :reviewee_id
    add_index :reviews, :reviewer_id
  end

  def self.down
    drop_table :reviews
  end
end
