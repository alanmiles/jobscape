class AddResponsibilitiesScoreToApplications < ActiveRecord::Migration
  def self.up
    add_column :applications, :responsibilities_score, :integer, :default => 0
  end

  def self.down
    remove_column :applications, :responsibilities_score
  end
end
