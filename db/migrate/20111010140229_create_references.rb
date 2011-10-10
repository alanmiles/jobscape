class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table :references do |t|
      t.integer :user_id
      t.string :name
      t.integer :relationship, :default => 4
      t.string :role
      t.string :location
      t.string :address
      t.string :phone
      t.string :email
      t.integer :portrait_rating, :default => 7

      t.timestamps
    end
  end

  def self.down
    drop_table :references
  end
end
