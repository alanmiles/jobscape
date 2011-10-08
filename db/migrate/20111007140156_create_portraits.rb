class CreatePortraits < ActiveRecord::Migration
  def self.up
    create_table :portraits do |t|
      t.integer :user_id
      t.boolean :worked_before, :default => false
      t.boolean :right_to_work, :default => false
      t.string :notes
      t.boolean :public, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :portraits
  end
end
