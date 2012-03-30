class CreateAmbitions < ActiveRecord::Migration
  def self.up
    create_table :ambitions do |t|
      t.integer :user_id
      t.string :ambition

      t.timestamps
    end
  end

  def self.down
    drop_table :ambitions
  end
end
