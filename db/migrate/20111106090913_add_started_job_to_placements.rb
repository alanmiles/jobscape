class AddStartedJobToPlacements < ActiveRecord::Migration
  def self.up
    add_column :placements, :started_job, :date
  end

  def self.down
    remove_column :placements, :started_job
  end
end
