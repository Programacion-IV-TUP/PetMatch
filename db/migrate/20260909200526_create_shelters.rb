class CreateShelters < ActiveRecord::Migration[8.1]
  def change
    create_table :shelters do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :description
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
