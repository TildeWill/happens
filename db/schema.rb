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

ActiveRecord::Schema.define(version: 2021_09_07_212728) do

  create_table "leaves", force: :cascade do |t|
    t.date "effective_on"
    t.string "furcate_identifier"
    t.integer "person_content_id"
    t.text "ancestry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestry"], name: "index_leaves_on_ancestry"
    t.index ["effective_on"], name: "index_leaves_on_effective_on"
    t.index ["furcate_identifier"], name: "index_leaves_on_furcate_identifier"
  end

  create_table "person_contents", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.integer "manager_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
