class AddShelterToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :shelter, null: true, foreign_key: true
  end
end
