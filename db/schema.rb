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

ActiveRecord::Schema[8.1].define(version: 2024_11_18_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "owner", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stores_on_name"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "card", limit: 12, null: false
    t.string "cpf", limit: 11, null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "description", null: false
    t.string "nature", null: false
    t.bigint "store_id", null: false
    t.time "time", null: false
    t.integer "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_transactions_on_date"
    t.index ["store_id"], name: "index_transactions_on_store_id"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
  end

  add_foreign_key "transactions", "stores"
end
