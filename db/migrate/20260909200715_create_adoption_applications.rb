class CreateAdoptionApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :adoption_applications do |t|
      t.string :housing_type
      t.boolean :has_another_pet
      t.text :notes
      t.string :status
      t.references :pet, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
