class CreateMedicalRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_records do |t|
      t.string :title
      t.date :performed_at
      t.text :notes
      t.date :next_due_date
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
