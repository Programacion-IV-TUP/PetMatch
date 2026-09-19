class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: 'adopter'
      t.string :phone
      t.references :address, foreign_key: true, null: true
      t.references :shelter, foreign_key: true, null: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
