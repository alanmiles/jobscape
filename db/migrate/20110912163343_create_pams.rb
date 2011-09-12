class CreatePams < ActiveRecord::Migration
  def self.up
    create_table :pams do |t|
      t.integer :quality_id
      t.string :grade
      t.string :descriptor
      t.integer :updated_by
      t.boolean :approved, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :pams
  end
end
