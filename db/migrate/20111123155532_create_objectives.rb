class CreateObjectives < ActiveRecord::Migration
  def self.up
    create_table :objectives do |t|
      t.integer :business_id
      t.string :objective
      t.integer :focus
      t.string :measurement 

      t.timestamps
    end
  end

  def self.down
    drop_table :objectives
  end
end
