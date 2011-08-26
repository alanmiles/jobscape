class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table 	:businesses do |t|
      t.string 		:name
      t.string 		:address
      t.string          :city
      t.string          :country
      t.float 		:latitude
      t.float 		:longitude

      t.timestamps
    end
  end

  def self.down
    drop_table :businesses
  end
end
