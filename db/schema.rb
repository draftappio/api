# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170306113828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.integer  "project_id"
    t.string   "key"
    t.json     "parameters",     default: {}, null: false
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["project_id"], name: "index_activities_on_project_id", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "artboards", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "object_id"
    t.string   "page_object_id"
    t.string   "page_name"
    t.string   "name"
    t.string   "slug"
    t.integer  "status",         default: 0
    t.integer  "width"
    t.integer  "height"
    t.datetime "due_date"
    t.string   "token"
    t.json     "layers"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "style"
    t.integer  "user_id"
    t.index ["project_id"], name: "index_artboards_on_project_id", using: :btree
    t.index ["user_id"], name: "index_artboards_on_user_id", using: :btree
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
  end

  create_table "authentication_providers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_name_on_authentication_providers", using: :btree
  end

  create_table "beta_requesters", force: :cascade do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "implemented_screens", force: :cascade do |t|
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
    t.integer  "project_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["project_id"], name: "index_implemented_screens_on_project_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.string   "email"
    t.integer  "team_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["email"], name: "index_invites_on_email", using: :btree
    t.index ["recipient_id"], name: "index_invites_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_invites_on_sender_id", using: :btree
    t.index ["team_id"], name: "index_invites_on_team_id", using: :btree
    t.index ["token"], name: "index_invites_on_token", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "artboard_id"
    t.string   "link"
    t.boolean  "public"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["artboard_id"], name: "index_links_on_artboard_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.integer "role",    default: 0
    t.index ["team_id"], name: "index_memberships_on_team_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "note_replies", force: :cascade do |t|
    t.string   "text"
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["note_id"], name: "index_note_replies_on_note_id", using: :btree
    t.index ["user_id"], name: "index_note_replies_on_user_id", using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "artboard_id"
    t.integer  "user_id"
    t.string   "object_id"
    t.boolean  "resolved"
    t.text     "note"
    t.json     "rect"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["artboard_id"], name: "index_notes_on_artboard_id", using: :btree
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "notification_settings", force: :cascade do |t|
    t.boolean  "summary"
    t.boolean  "mention_me"
    t.boolean  "create_project"
    t.boolean  "project_comment"
    t.boolean  "new_features"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.boolean  "weekly_summary"
    t.index ["user_id"], name: "index_notification_settings_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "platform"
    t.string   "thumb"
    t.string   "scale"
    t.string   "unit"
    t.string   "color_format"
    t.integer  "artboards_count", default: 0
    t.json     "slices"
    t.json     "colors"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "status",          default: 0
    t.datetime "due_date"
    t.boolean  "archived",        default: false, null: false
    t.json     "fonts"
    t.index ["slug"], name: "index_projects_on_slug", using: :btree
  end

  create_table "styleguides", force: :cascade do |t|
    t.integer  "project_id"
    t.json     "colors"
    t.json     "fonts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_styleguides_on_project_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string  "taggable_type"
    t.integer "taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "color"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "project_id"
    t.index ["project_id"], name: "index_teams_on_project_id", using: :btree
  end

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "authentication_provider_id"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expires_at"
    t.text     "params"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["authentication_provider_id"], name: "index_user_authentications_on_authentication_provider_id", using: :btree
    t.index ["user_id"], name: "index_user_authentications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: ""
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "name"
    t.string   "nickname"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  add_foreign_key "artboards", "users"
  add_foreign_key "implemented_screens", "projects"
  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "note_replies", "users"
  add_foreign_key "notification_settings", "users"
  add_foreign_key "teams", "projects"
end
