class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :placement_id
      t.string :task
      t.boolean :completed, :default => false
      t.date :task_date 

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
