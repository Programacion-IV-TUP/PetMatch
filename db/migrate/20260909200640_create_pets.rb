class CreatePets < ActiveRecord::Migration[8.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :age_months
      t.string :size
      t.float :weight
      t.string :gender
      t.text :description
      t.string :status
      t.references :breed, null: false, foreign_key: true
      t.references :shelter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
