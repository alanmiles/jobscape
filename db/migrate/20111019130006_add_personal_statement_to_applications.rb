class AddPersonalStatementToApplications < ActiveRecord::Migration
  def self.up
    add_column :applications, :personal_statement, :string
  end

  def self.down
    remove_column :applications, :personal_statement
  end
end
