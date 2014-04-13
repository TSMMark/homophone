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

ActiveRecord::Schema.define(version: 20140412151339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "definitions", force: true do |t|
    t.integer  "word_id"
    t.string   "text"
    t.string   "part_of_speech"
    t.string   "source_dictionary"
    t.string   "attribution_text"
    t.string   "attribution_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "definitions", ["word_id"], name: "index_definitions_on_word_id", using: :btree

  create_table "word_sets", force: true do |t|
    t.integer  "visits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", force: true do |t|
    t.string   "text"
    t.integer  "visits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "no_definitions"
    t.string   "display_text"
    t.integer  "word_set_id"
  end

  add_index "words", ["word_set_id"], name: "index_words_on_word_set_id", using: :btree

end
