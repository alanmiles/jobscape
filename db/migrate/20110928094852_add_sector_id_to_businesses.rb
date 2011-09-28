class AddSectorIdToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :sector_id, :integer
  end

  def self.down
    remove_column :businesses, :sector_id
  end
end
