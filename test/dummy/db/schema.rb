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

ActiveRecord::Schema.define(version: 20160518094932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "g_game_board_players", force: :cascade do |t|
    t.integer  "g_game_board_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "g_game_board_players", ["g_game_board_id"], name: "index_g_game_board_players_on_g_game_board_id", using: :btree

  create_table "g_game_boards", force: :cascade do |t|
    t.integer  "turn",       default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "h_houses", force: :cascade do |t|
    t.string   "code_name",           null: false
    t.integer  "h_suzerain_house_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "h_houses", ["code_name"], name: "index_h_houses_on_code_name", unique: true, using: :btree
  add_index "h_houses", ["h_suzerain_house_id"], name: "index_h_houses_on_h_suzerain_house_id", using: :btree

  create_table "westeros_alliances_al_bets", force: :cascade do |t|
    t.integer  "g_game_board_id",               null: false
    t.integer  "h_house_id",                    null: false
    t.integer  "h_target_house_id",             null: false
    t.integer  "bet",               default: 0, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "westeros_alliances_al_bets", ["g_game_board_id", "h_house_id", "h_target_house_id"], name: "al_bets_unique_index", unique: true, using: :btree

  create_table "westeros_alliances_al_houses", force: :cascade do |t|
    t.integer  "g_game_board_id",                      null: false
    t.integer  "h_house_id",                           null: false
    t.boolean  "minor_alliance_member", default: true
    t.integer  "last_bet",              default: 0,    null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "westeros_alliances_al_houses", ["g_game_board_id", "h_house_id"], name: "al_houses_unique_index", unique: true, using: :btree

  create_table "westeros_alliances_al_logs", force: :cascade do |t|
    t.integer  "g_game_board_id",  null: false
    t.integer  "log_code",         null: false
    t.text     "alliance_details"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "westeros_alliances_al_logs", ["g_game_board_id"], name: "index_westeros_alliances_al_logs_on_g_game_board_id", using: :btree

  create_table "westeros_alliances_al_relationships", force: :cascade do |t|
    t.integer  "g_game_board_id", null: false
    t.integer  "h_house_id",      null: false
    t.integer  "h_peer_house_id", null: false
    t.string   "type",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "westeros_alliances_al_relationships", ["g_game_board_id", "h_house_id", "h_peer_house_id"], name: "al_relationships_unique_index", unique: true, using: :btree
  add_index "westeros_alliances_al_relationships", ["type"], name: "index_westeros_alliances_al_relationships_on_type", using: :btree

  add_foreign_key "g_game_board_players", "g_game_boards"
  add_foreign_key "h_houses", "h_houses", column: "h_suzerain_house_id"
  add_foreign_key "westeros_alliances_al_bets", "g_game_boards"
  add_foreign_key "westeros_alliances_al_bets", "h_houses"
  add_foreign_key "westeros_alliances_al_bets", "h_houses", column: "h_target_house_id"
  add_foreign_key "westeros_alliances_al_houses", "g_game_boards"
  add_foreign_key "westeros_alliances_al_houses", "h_houses"
  add_foreign_key "westeros_alliances_al_logs", "g_game_boards"
  add_foreign_key "westeros_alliances_al_relationships", "g_game_boards"
  add_foreign_key "westeros_alliances_al_relationships", "h_houses"
  add_foreign_key "westeros_alliances_al_relationships", "h_houses", column: "h_peer_house_id"
end
