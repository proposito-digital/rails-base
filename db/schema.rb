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

ActiveRecord::Schema[8.1].define(version: 2026_08_13_000000) do
  create_table "birds", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_birds_on_deleted_at"
  end

  create_table "cats", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_cats_on_deleted_at"
  end

  create_table "dogs", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_dogs_on_deleted_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
