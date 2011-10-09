class CreateAims < ActiveRecord::Migration
  def self.up
    create_table :aims do |t|
      t.integer :user_id
      t.string :aim
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :aims
  end
end
