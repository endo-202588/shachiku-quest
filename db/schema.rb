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

ActiveRecord::Schema[7.2].define(version: 2026_02_18_043052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "app_settings", force: :cascade do |t|
    t.string "key", null: false
    t.string "value", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_app_settings_on_key", unique: true
  end

  create_table "help_magics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "available_time", default: 0, null: false
    t.date "available_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "available_date"], name: "index_help_magics_on_user_id_and_available_date"
    t.index ["user_id"], name: "index_help_magics_on_user_id"
  end

  create_table "help_request_messages", force: :cascade do |t|
    t.bigint "help_request_id", null: false
    t.bigint "sender_id"
    t.bigint "recipient_id", null: false
    t.integer "message_type", null: false
    t.text "body", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["help_request_id", "created_at"], name: "index_help_request_messages_on_help_request_id_and_created_at"
    t.index ["help_request_id"], name: "index_help_request_messages_on_help_request_id"
    t.index ["recipient_id", "read_at"], name: "index_help_request_messages_on_recipient_id_and_read_at"
    t.index ["recipient_id"], name: "index_help_request_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_help_request_messages_on_sender_id"
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
    t.text "request_message"
    t.text "helper_message"
    t.integer "virtue_points", default: 10, null: false
    t.date "matched_on"
    t.datetime "matched_notified_at"
    t.index ["helper_id"], name: "index_help_requests_on_helper_id"
    t.index ["last_helper_id"], name: "index_help_requests_on_last_helper_id"
    t.index ["status"], name: "index_help_requests_on_status"
    t.index ["task_id", "helper_id"], name: "index_help_requests_on_task_id_and_helper_id", unique: true
    t.index ["task_id"], name: "index_help_requests_on_task_id"
  end

  create_table "personality_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status_type", default: 0, null: false
    t.date "status_date", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "status_date"], name: "index_statuses_on_user_id_and_status_date", unique: true
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

  create_table "user_personality_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "personality_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personality_tag_id"], name: "index_user_personality_tags_on_personality_tag_id"
    t.index ["user_id", "personality_tag_id"], name: "index_user_personality_tags_on_user_id_and_personality_tag_id", unique: true
    t.index ["user_id"], name: "index_user_personality_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "department"
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.integer "level", default: 1, null: false
    t.integer "total_virtue_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unconfirmed_email"
    t.string "email_change_token"
    t.datetime "email_change_token_expires_at"
    t.integer "role", default: 0, null: false
    t.string "nickname"
    t.string "hobbies"
    t.text "introduction"
    t.datetime "total_virtue_points_notified_at"
    t.datetime "total_virtue_points_read_at"
    t.integer "total_virtue_points_last_added"
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["email_change_token"], name: "index_users_on_email_change_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unconfirmed_email"], name: "index_users_on_unconfirmed_email"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "help_magics", "users"
  add_foreign_key "help_request_messages", "help_requests"
  add_foreign_key "help_request_messages", "users", column: "recipient_id"
  add_foreign_key "help_request_messages", "users", column: "sender_id"
  add_foreign_key "help_requests", "tasks"
  add_foreign_key "help_requests", "users", column: "helper_id"
  add_foreign_key "statuses", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_personality_tags", "personality_tags"
  add_foreign_key "user_personality_tags", "users"
end
