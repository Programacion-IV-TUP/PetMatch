# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_22_205905) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "apartment"
    t.integer "city_id", null: false
    t.datetime "created_at", null: false
    t.integer "floor"
    t.string "number"
    t.string "street"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["city_id"], name: "index_addresses_on_city_id"
  end

  create_table "adoption_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "has_another_pet"
    t.string "housing_type"
    t.text "notes"
    t.integer "pet_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pet_id", "status"], name: "index_adoption_applications_on_pet_id_and_status"
    t.index ["pet_id"], name: "index_adoption_applications_on_pet_id"
    t.index ["status"], name: "index_adoption_applications_on_status"
    t.index ["user_id"], name: "index_adoption_applications_on_user_id"
  end

  create_table "breeds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "species"
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "state"
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "pet_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pet_id"], name: "index_favorites_on_pet_id"
    t.index ["user_id", "pet_id"], name: "index_favorites_on_user_id_and_pet_id", unique: true
  end

  create_table "medical_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "next_due_date"
    t.text "notes"
    t.date "performed_at"
    t.integer "pet_id", null: false
    t.string "record_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_medical_records_on_pet_id"
  end

  create_table "pets", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "age_months"
    t.integer "breed_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "gender"
    t.string "name"
    t.integer "shelter_id", null: false
    t.string "size"
    t.string "status"
    t.datetime "updated_at", null: false
    t.float "weight"
    t.index ["active"], name: "index_pets_on_active"
    t.index ["breed_id"], name: "index_pets_on_breed_id"
    t.index ["shelter_id", "status"], name: "index_pets_on_shelter_id_and_status"
    t.index ["shelter_id"], name: "index_pets_on_shelter_id"
    t.index ["status"], name: "index_pets_on_status"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shelters", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["active"], name: "index_shelters_on_active"
    t.index ["address_id"], name: "index_shelters_on_address_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.integer "address_id", null: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.string "role", default: "adopter", null: false
    t.integer "shelter_id"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["address_id"], name: "index_users_on_address_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["shelter_id"], name: "index_users_on_shelter_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "cities"
  add_foreign_key "adoption_applications", "pets"
  add_foreign_key "adoption_applications", "users"
  add_foreign_key "favorites", "pets"
  add_foreign_key "favorites", "users"
  add_foreign_key "medical_records", "pets"
  add_foreign_key "pets", "breeds"
  add_foreign_key "pets", "shelters"
  add_foreign_key "sessions", "users"
  add_foreign_key "shelters", "addresses"
  add_foreign_key "users", "addresses"
  add_foreign_key "users", "shelters"
end
