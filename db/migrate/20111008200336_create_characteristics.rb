class CreateCharacteristics < ActiveRecord::Migration
  def self.up
    create_table :characteristics do |t|
      t.integer :user_id
      t.string :characteristic
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :characteristics
  end
end
