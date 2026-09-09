class CreateBreeds < ActiveRecord::Migration[8.1]
  def change
    create_table :breeds do |t|
      t.string :name
      t.string :species

      t.timestamps
    end
  end
end
