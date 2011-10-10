class CreatePreviousjobs < ActiveRecord::Migration
  def self.up
    create_table :previousjobs do |t|
      t.integer :user_id
      t.string :job
      t.integer :years, :default => 0
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :previousjobs
  end
end
