class CreateApplicqualities < ActiveRecord::Migration
  def self.up
    create_table :applicqualities do |t|
      t.integer :application_id
      t.integer :quality_id
      t.integer :position
      t.integer :applicant_score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :applicqualities
  end
end
