class CreateResponsibilities < ActiveRecord::Migration
  def self.up
    create_table :responsibilities do |t|
      t.integer :plan_id
      t.string :definition
      t.integer :rating, :default => 0
      t.boolean :removed, :default => false
      t.date :removal_date
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :responsibilities
  end
end
