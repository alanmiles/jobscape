class CreateApplicrequirements < ActiveRecord::Migration
  def self.up
    create_table :applicrequirements do |t|
      t.integer :application_id
      t.integer :requirement_id
      t.integer :position
      t.integer :applicant_score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :applicrequirements
  end
end
