class AddNullConstraintsToUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :first_name, false
    change_column_null :users, :second_name, false
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
    change_column_null :users, :role, false
    
    change_column_default :users, :role, from: nil, to: 'adopter'
    
    unless index_exists?(:users, :email, unique: true)
      add_index :users, :email, unique: true
    end
  end
end