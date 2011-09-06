class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :job_title
      t.integer :business_id
      t.integer :occupation_id
      t.boolean :vacancy, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
