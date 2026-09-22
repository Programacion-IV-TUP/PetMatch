class AddActiveAndIndexesToCoreModels < ActiveRecord::Migration[8.1]
  def change
    # 1. Add active column to shelters and pets (users already has active:boolean)
    add_column :shelters, :active, :boolean, default: true, null: false unless column_exists?(:shelters, :active)
    add_column :pets, :active, :boolean, default: true, null: false unless column_exists?(:pets, :active)

    # 2. Indexes for Soft Delete (active column)
    add_index :users, :active unless index_exists?(:users, :active)
    add_index :shelters, :active unless index_exists?(:shelters, :active)
    add_index :pets, :active unless index_exists?(:pets, :active)

    # 3. Performance indexes for Search, Filtering & Status Updates
    add_index :pets, :status unless index_exists?(:pets, :status)
    add_index :pets, [ :shelter_id, :status ] unless index_exists?(:pets, [ :shelter_id, :status ])

    add_index :adoption_applications, :status unless index_exists?(:adoption_applications, :status)
    add_index :adoption_applications, [ :pet_id, :status ] unless index_exists?(:adoption_applications, [ :pet_id, :status ])

    # 4. Unique index for Favorites (removes single user_id index if present)
    remove_index :favorites, :user_id if index_exists?(:favorites, :user_id) && !index_exists?(:favorites, [ :user_id, :pet_id ])
    add_index :favorites, [ :user_id, :pet_id ], unique: true unless index_exists?(:favorites, [ :user_id, :pet_id ])
  end
end
