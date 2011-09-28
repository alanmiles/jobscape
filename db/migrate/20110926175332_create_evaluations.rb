class CreateEvaluations < ActiveRecord::Migration
  def self.up
    create_table :evaluations do |t|
      t.integer :responsibility_id
      t.integer :profits, :default => 0
      t.integer :customers, :default => 0
      t.integer :staff, :default => 0
      t.integer :processes, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :evaluations
  end
end
