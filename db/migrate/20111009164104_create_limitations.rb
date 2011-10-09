class CreateLimitations < ActiveRecord::Migration
  def self.up
    create_table :limitations do |t|
      t.integer :user_id
      t.string :limitation
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :limitations
  end
end
