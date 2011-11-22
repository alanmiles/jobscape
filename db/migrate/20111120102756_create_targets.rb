class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.integer :placement_id
      t.string :target
      t.date :target_date
      t.boolean :achieved, :default => false
      t.boolean :cancelled, :default => false
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :targets
  end
end
