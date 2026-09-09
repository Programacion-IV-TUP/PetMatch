class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :number
      t.string :zip_code
      t.integer :floor
      t.string :apartment
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
