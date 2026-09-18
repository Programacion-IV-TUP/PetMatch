class AddStateToCity < ActiveRecord::Migration[8.1]
  def change
    add_column :cities, :state, :string
  end
end
