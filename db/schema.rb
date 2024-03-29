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

ActiveRecord::Schema[7.0].define(version: 2016_11_28_190308) do
  create_table "items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "width"
    t.decimal "height"
    t.integer "lister_id"
    t.string "email"
    t.string "img_loc"
    t.text "img_sml_loc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
