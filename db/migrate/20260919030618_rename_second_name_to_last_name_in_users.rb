class RenameSecondNameToLastNameInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :second_name, :last_name
  end
end
