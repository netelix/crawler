# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_18_142257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.datetime "crawled_at"
    t.json "emails"
    t.json "phones"
    t.json "postcodes"
    t.string "host"
    t.string "error"
    t.json "backlink_hosts"
    t.string "redirect_to"
    t.string "domain_status"
    t.string "majestic_trust_flow"
    t.string "majestic_citation_flow"
    t.string "ahref_note"
    t.json "history_titles"
    t.index ["url"], name: "index_pages_on_url", unique: true
  end

end
