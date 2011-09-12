class CreateQualities < ActiveRecord::Migration
  def self.up
    create_table :qualities do |t|
      t.string :quality
      t.boolean :approved, :default => false
      t.integer :created_by
      t.integer :business_id
      t.integer :updated_by
      t.boolean :seen, :default => false
      t.boolean :removed, :default => false
      t.date :removal_date

      t.timestamps
    end
  end

  def self.down
    drop_table :qualities
  end
end
