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

ActiveRecord::Schema.define(version: 20170717045238) do

  create_table "server_info", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "location"
    t.datetime "timestamp"
  end

  create_table "tph_data", id: false, force: :cascade do |t|
    t.datetime "timestamp"
    t.float "t"
    t.float "p"
    t.float "h"
    t.index ["timestamp"], name: "index_tph_data_on_timestamp"
  end

end