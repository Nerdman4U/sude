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

ActiveRecord::Schema.define(version: 20170731071546) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "group_permissions", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.string "acl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_permissions_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_permissions_on_group_id"
    t.index ["user_id"], name: "index_group_permissions_on_user_id"
  end

  create_table "group_vote_proposals", force: :cascade do |t|
    t.integer "group_id"
    t.integer "vote_proposal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_vote_proposals_on_group_id"
    t.index ["vote_proposal_id"], name: "index_group_vote_proposals_on_vote_proposal_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "user_vote_proposals", force: :cascade do |t|
    t.integer "user_id"
    t.integer "vote_proposal_id"
    t.index ["user_id"], name: "index_user_vote_proposals_on_user_id"
    t.index ["vote_proposal_id"], name: "index_user_vote_proposals_on_vote_proposal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "username"
    t.string "fullname"
    t.integer "confirmed"
    t.integer "foo"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vote_proposal_options", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_vote_proposal_options_on_name", unique: true
  end

  create_table "vote_proposal_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_vote_proposal_tags_on_name", unique: true
  end

  create_table "vote_proposal_vote_proposal_options", force: :cascade do |t|
    t.integer "vote_proposal_id"
    t.integer "vote_proposal_option_id"
    t.integer "anonymous_vote_count"
    t.integer "confirmed_vote_count"
    t.index ["vote_proposal_id"], name: "vopovopoop_vopo_id"
    t.index ["vote_proposal_option_id"], name: "vopovopoop_vopoop_id"
  end

  create_table "vote_proposal_vote_proposal_tags", force: :cascade do |t|
    t.integer "vote_proposal_id"
    t.integer "vote_proposal_tag_id"
    t.index ["vote_proposal_id"], name: "vopovopota_vopo_id"
    t.index ["vote_proposal_tag_id"], name: "vopovopota_vopota_id"
  end

  create_table "vote_proposals", force: :cascade do |t|
    t.string "topic"
    t.integer "min_options"
    t.integer "max_options"
    t.datetime "published_at"
    t.datetime "viewable_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "anonymous_vote_count"
    t.integer "confirmed_vote_count"
  end

  create_table "vote_vote_proposal_options", force: :cascade do |t|
    t.integer "vote_id"
    t.integer "vote_proposal_option_id"
    t.index ["vote_id"], name: "index_vote_vote_proposal_options_on_vote_id"
    t.index ["vote_proposal_option_id"], name: "index_vote_vote_proposal_options_on_vote_proposal_option_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "vote_proposal_id"
    t.string "selected_options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["vote_proposal_id"], name: "index_votes_on_vote_proposal_id"
  end

end
