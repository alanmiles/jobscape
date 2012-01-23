class CreateLetterTemplates < ActiveRecord::Migration
  def self.up
    create_table :letter_templates do |t|
      t.string :description
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :letter_templates
  end
end
