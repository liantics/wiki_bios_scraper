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

ActiveRecord::Schema.define(version: 20141104044623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "biographies", force: true do |t|
    t.string   "name",                                     null: false
    t.string   "url",                                      null: false
    t.string   "rough_gender",    default: "unknown",      null: false
    t.string   "verified_gender", default: "not verified", null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "biography_class"
  end

  create_table "biography_statistics", force: true do |t|
    t.string   "name",           null: false
    t.float    "value",          null: false
    t.string   "statistic_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "wiki_biography_classes", force: true do |t|
    t.text     "class_type"
    t.text     "class_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "traversal_status"
  end

end
