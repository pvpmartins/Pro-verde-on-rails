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

ActiveRecord::Schema[8.0].define(version: 2025_04_19_025734) do
  create_table "addresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "complement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "address_type"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.index ["category_id"], name: "index_categories_on_category_id"
  end

  create_table "plan_frequencies", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.integer "frequency_type"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_plan_frequencies_on_plan_id"
  end

  create_table "plan_version_products", force: :cascade do |t|
    t.integer "plan_version_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["plan_version_id"], name: "index_plan_version_products_on_plan_version_id"
    t.index ["product_id"], name: "index_plan_version_products_on_product_id"
  end

  create_table "plan_versions", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.date "version_date"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_plan_versions_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "features", default: "[]"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.decimal "amount"
    t.string "unit_measure"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "can_create_product", default: false
    t.boolean "can_edit_product", default: false
    t.boolean "can_delete_product", default: false
    t.boolean "can_create_plan", default: false
    t.boolean "can_edit_plan", default: false
    t.boolean "can_delete_plan", default: false
    t.boolean "can_create_subscription", default: false
    t.boolean "can_edit_subscription", default: false
    t.boolean "can_delete_subscription", default: false
    t.boolean "can_access_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "start_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan_frequency_id", null: false
    t.index ["plan_frequency_id"], name: "index_subscriptions_on_plan_frequency_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "categories", "categories"
  add_foreign_key "plan_frequencies", "plans"
  add_foreign_key "plan_version_products", "plan_versions"
  add_foreign_key "plan_version_products", "products"
  add_foreign_key "plan_versions", "plans"
  add_foreign_key "products", "categories"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscriptions", "plan_frequencies"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "users", "roles"
end
