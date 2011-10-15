class CreatePlacements < ActiveRecord::Migration
  def self.up
    create_table :placements do |t|
      t.integer :user_id
      t.integer :job_id
      t.boolean :current, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :placements
  end
end
