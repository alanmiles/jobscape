class CreateApplicresponsibilities < ActiveRecord::Migration
  def self.up
    create_table :applicresponsibilities do |t|
      t.integer :application_id
      t.integer :responsibility_id
      t.integer :position
      t.integer :applicant_score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :applicresponsibilities
  end
end
