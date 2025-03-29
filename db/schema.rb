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

ActiveRecord::Schema[8.0].define(version: 2025_03_18_144740) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "leave_requests", force: :cascade do |t|
    t.bigint "hr_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "reason", null: false
    t.string "status", default: "Pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.index ["employee_id"], name: "index_leave_requests_on_employee_id"
    t.index ["hr_id"], name: "index_leave_requests_on_hr_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.integer "leave_balance", default: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "leave_requests", "users", column: "hr_id"
end
