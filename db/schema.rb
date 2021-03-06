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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130708172705) do

  create_table "changelogs", :force => true do |t|
    t.integer  "timesheet_id"
    t.string   "changed_by"
    t.datetime "old_in"
    t.datetime "new_in"
    t.datetime "old_out"
    t.datetime "new_out"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "changelogs", ["timesheet_id", "created_at"], :name => "index_changelogs_on_timesheet_id_and_created_at"

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "manager",            :default => false
    t.boolean  "clocked_in",         :default => false
    t.boolean  "active_employee",    :default => true
    t.string   "employee_time_zone", :default => "UTC"
  end

  add_index "employees", ["remember_token"], :name => "index_employees_on_remember_token"
  add_index "employees", ["username"], :name => "index_employees_on_username", :unique => true

  create_table "timesheets", :force => true do |t|
    t.datetime "punch_in"
    t.datetime "punch_out"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "timesheets", ["employee_id", "created_at"], :name => "index_timesheets_on_employee_id_and_created_at"

end
