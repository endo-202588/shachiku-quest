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

ActiveRecord::Schema[7.2].define(version: 2026_01_21_094854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "help_magics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "available_time", default: 0, null: false
    t.date "available_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "available_date"], name: "index_help_magics_on_user_id_and_available_date"
    t.index ["user_id"], name: "index_help_magics_on_user_id"
  end

  create_table "help_requests", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "helper_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "required_time", default: 0, null: false
    t.bigint "last_helper_id"
    t.datetime "completed_notified_at"
    t.datetime "completed_read_at"
    t.index ["helper_id"], name: "index_help_requests_on_helper_id"
    t.index ["last_helper_id"], name: "index_help_requests_on_last_helper_id"
    t.index ["status"], name: "index_help_requests_on_status"
    t.index ["task_id", "helper_id"], name: "index_help_requests_on_task_id_and_helper_id", unique: true
    t.index ["task_id"], name: "index_help_requests_on_task_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status_type", default: 0, null: false
    t.date "status_date", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "department"
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "avatar"
    t.integer "level", default: 0, null: false
    t.integer "total_virtue_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "help_magics", "users"
  add_foreign_key "help_requests", "tasks"
  add_foreign_key "help_requests", "users", column: "helper_id"
  add_foreign_key "statuses", "users"
  add_foreign_key "tasks", "users"
end
