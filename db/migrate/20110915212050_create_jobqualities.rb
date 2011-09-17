class CreateJobqualities < ActiveRecord::Migration
  def self.up
    create_table :jobqualities do |t|
      t.integer :plan_id
      t.integer :quality_id

      t.timestamps
    end
    add_index :jobqualities, :plan_id
    add_index :jobqualities, :quality_id
    add_index :jobqualities, [:plan_id, :quality_id], :unique => true 
  end

  def self.down
    drop_table :jobqualities
  end
end
