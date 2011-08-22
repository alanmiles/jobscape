class CreateOccupations < ActiveRecord::Migration
  def self.up
    create_table :occupations do |t|
      t.string :name

      t.timestamps
    end
    add_index :occupations, :name
  end

  def self.down
    drop_table :occupations
  end
end
