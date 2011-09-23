class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.integer :plan_id
      t.string :requirement
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
