class CreateVacancies < ActiveRecord::Migration
  def self.up
    create_table :vacancies do |t|
      t.integer :job_id
      t.integer :sector_id
      t.integer :annual_salary
      t.decimal :hourly_rate, :precision => 5, :scale => 2
      t.boolean :voluntary, :default => false
      t.boolean :filled, :default => false
      t.string :notes
      t.string :contact_person
      t.string :contact_email

      t.timestamps
    end
  end

  def self.down
    drop_table :vacancies
  end
end
