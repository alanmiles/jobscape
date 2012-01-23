class AddEmployerActionToApplications < ActiveRecord::Migration
  def self.up
    remove_column :applications, :employer_shortlist
    add_column :applications, :employer_action, :integer, :default => 0
    add_column :applications, :hygwit_score, :integer, :default => 0  
  end

  def self.down
    remove_column :applications, :employer_action
    remove_column :applications, :hygwit_score
    add_column :applications, :employer_shortlist, :boolean, :default => false
    
  end
end
