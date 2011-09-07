class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :job_id
      t.boolean :responsibilities, :default => false
      t.boolean :goals, :default => false
      t.boolean :personal_attributes, :default => false
      t.boolean :recruitment_factors, :default => false
      t.boolean :summary, :default => false
      t.boolean :evaluation, :default => false
      t.integer :job_value
      t.integer :last_edited_by

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
