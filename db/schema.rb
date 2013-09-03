# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130903001700) do

  create_table "draft_picks", force: true do |t|
    t.integer "league_id", null: false
    t.integer "member_id", null: false
    t.integer "order",     null: false
    t.integer "team_id"
  end

  add_index "draft_picks", ["league_id", "team_id"], name: "index_draft_picks_on_league_id_and_team_id", unique: true, using: :btree

  create_table "league_memberships", force: true do |t|
    t.integer  "league_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: true do |t|
    t.string   "name",            null: false
    t.integer  "commissioner_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
