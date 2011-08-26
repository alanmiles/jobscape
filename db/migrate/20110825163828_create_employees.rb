class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.integer :user_id
      t.integer :business_id
      t.boolean :officer, :default => false

      t.timestamps
    end
    add_index :employees, :user_id
    add_index :employees, :business_id
    add_index :employees, [:user_id, :business_id], :unique => true
  end

  def self.down
    drop_table :employees
  end
end
