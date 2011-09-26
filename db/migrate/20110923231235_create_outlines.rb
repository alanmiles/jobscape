class CreateOutlines < ActiveRecord::Migration
  def self.up
    create_table :outlines do |t|
      t.integer :job_id
      t.text :role, :default => "Your role is to "
      t.text :qualities, :default => "To do this job well, you need "
      t.text :importance, :default => "The job is important to the organization because "

      t.timestamps
    end
  end

  def self.down
    drop_table :outlines
  end
end
