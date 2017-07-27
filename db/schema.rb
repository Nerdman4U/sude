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

ActiveRecord::Schema.define(version: 20170727082950) do

  create_table "group_permissions", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.string "acl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "ip"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
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
    t.index ["vote_proposal_id"], name: "vopovopoop_vopo_id"
    t.index ["vote_proposal_option_id"], name: "vopovopoop_vopoop_id"
  end

  create_table "vote_proposal_vote_proposal_tags", force: :cascade do |t|
    t.integer "vote_proposal_id"
    t.integer "vote_proposal_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
