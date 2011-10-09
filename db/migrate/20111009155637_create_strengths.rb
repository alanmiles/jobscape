class CreateStrengths < ActiveRecord::Migration
  def self.up
    create_table :strengths do |t|
      t.integer :user_id
      t.string :strength
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :strengths
  end
end
