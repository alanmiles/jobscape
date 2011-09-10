class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.integer :responsibility_id
      t.string :objective
      t.boolean :removed, :default => false
      t.date :removal_date
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
