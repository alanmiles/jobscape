class AddDepartmentIdToPlacements < ActiveRecord::Migration
  def self.up
    add_column :placements, :department_id, :integer
  end

  def self.down
    remove_column :placements, :department_id
  end
end
