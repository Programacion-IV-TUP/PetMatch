class AddWebsiteToShelters < ActiveRecord::Migration[8.1]
  def change
    add_column :shelters, :website, :string
  end
end
