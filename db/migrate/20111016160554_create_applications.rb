class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.integer :vacancy_id
      t.integer :user_id
      t.integer :next_action, :default => 0
      t.boolean :submitted, :default => false
      t.date :submission_date
      t.integer :requirements_score, :default => 0
      t.integer :qualities_score, :default => 0
      t.integer :requirements_score, :default => 0
      t.integer :portrait_score, :default => 0
      t.boolean :employer_shortlist, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
