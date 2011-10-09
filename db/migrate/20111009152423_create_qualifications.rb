class CreateQualifications < ActiveRecord::Migration
  def self.up
    create_table :qualifications do |t|
      t.integer :user_id
      t.string :qualification
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :qualifications
  end
end
