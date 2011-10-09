class CreateFavourites < ActiveRecord::Migration
  def self.up
    create_table :favourites do |t|
      t.integer :user_id
      t.string :favourite
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :favourites
  end
end
