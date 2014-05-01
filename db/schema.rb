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

ActiveRecord::Schema.define(version: 20140501081759) do

  create_table "levelpacks", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "solution"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "levelpacks", ["name"], name: "index_levelpacks_on_name", unique: true

  create_table "levels", force: true do |t|
    t.string   "name"
    t.string   "img_src"
    t.string   "solution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "levelpack_id"
  end

  add_index "levels", ["levelpack_id"], name: "index_levels_on_levelpack_id", unique: true
  add_index "levels", ["name"], name: "index_levels_on_name", unique: true

  create_table "lp_l_relationships", force: true do |t|
    t.integer  "levelpack_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lp_l_relationships", ["level_id"], name: "index_lp_l_relationships_on_level_id"
  add_index "lp_l_relationships", ["levelpack_id", "level_id"], name: "index_lp_l_relationships_on_levelpack_id_and_level_id", unique: true
  add_index "lp_l_relationships", ["levelpack_id"], name: "index_lp_l_relationships_on_levelpack_id"

  create_table "u_lp_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "levelpack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "u_lp_relationships", ["levelpack_id"], name: "index_u_lp_relationships_on_levelpack_id"
  add_index "u_lp_relationships", ["user_id", "levelpack_id"], name: "index_u_lp_relationships_on_user_id_and_levelpack_id", unique: true
  add_index "u_lp_relationships", ["user_id"], name: "index_u_lp_relationships_on_user_id"

  create_table "users", force: true do |t|
    t.string   "naam"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "klas"
    t.string   "progress"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
