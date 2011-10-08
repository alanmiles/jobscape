class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.integer :user_id
      t.string :achievement
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end
