# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_03_190726) do

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.integer "manager_id"
    t.date "effective_on"
    t.string "version_identifier"
    t.string "ancestry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestry"], name: "index_people_on_ancestry"
    t.index ["effective_on"], name: "index_people_on_effective_on"
    t.index ["version_identifier"], name: "index_people_on_version_identifier"
  end

end
