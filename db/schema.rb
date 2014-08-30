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

ActiveRecord::Schema.define(version: 20130922183538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draft_picks", force: true do |t|
    t.integer  "league_id",  null: false
    t.integer  "member_id",  null: false
    t.integer  "order",      null: false
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "draft_picks", ["league_id", "team_id"], name: "index_draft_picks_on_league_id_and_team_id", unique: true, using: :btree
  add_index "draft_picks", ["league_id"], name: "index_draft_picks_on_league_id", using: :btree
  add_index "draft_picks", ["member_id"], name: "index_draft_picks_on_member_id", using: :btree

  create_table "league_memberships", force: true do |t|
    t.integer  "league_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "league_memberships", ["league_id", "member_id"], name: "index_league_memberships_on_league_id_and_member_id", unique: true, using: :btree

  create_table "leagues", force: true do |t|
    t.string   "name",                               null: false
    t.integer  "commissioner_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "draft_started_at"
    t.datetime "draft_completed_at"
    t.string   "sport",              default: "nfl"
  end

  add_index "leagues", ["commissioner_id"], name: "index_leagues_on_commissioner_id", using: :btree

  create_table "regular_season_games", force: true do |t|
    t.integer  "winner_id"
    t.integer  "week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "regular_season_games", ["type"], name: "index_regular_season_games_on_type", using: :btree
  add_index "regular_season_games", ["winner_id", "week"], name: "index_regular_season_games_on_winner_id_and_week", unique: true, using: :btree
  add_index "regular_season_games", ["winner_id"], name: "index_regular_season_games_on_winner_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "canceled_at"
    t.datetime "expires_at",  default: '1970-01-01 00:00:00'
  end

  add_index "subscriptions", ["user_id", "canceled_at"], name: "index_subscriptions_on_user_id_and_canceled_at", unique: true, using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "stripe_id"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
