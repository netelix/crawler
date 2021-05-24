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

ActiveRecord::Schema.define(version: 2021_05_24_174929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backlinks", force: :cascade do |t|
    t.bigint "from_id"
    t.bigint "to_id"
    t.index ["from_id"], name: "index_backlinks_on_from_id"
    t.index ["to_id"], name: "index_backlinks_on_to_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_emails_on_page_id"
  end

  create_table "hosts", force: :cascade do |t|
    t.string "host"
    t.string "domain_status"
    t.string "majestic_trust_flow"
    t.string "majestic_citation_flow"
    t.string "ahref_note"
    t.json "history_titles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "page_crawled_at"
    t.datetime "linked_hosts_crawled_at"
    t.text "filter"
    t.index ["domain_status"], name: "index_hosts_on_domain_status"
    t.index ["host"], name: "index_pages_on_host", unique: true
  end

  create_table "pages", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.datetime "crawled_at"
    t.json "emails"
    t.json "phones"
    t.json "postcodes"
    t.string "error"
    t.json "backlink_hosts"
    t.string "redirect_to"
    t.string "domain_status"
    t.string "majestic_trust_flow"
    t.string "majestic_citation_flow"
    t.string "ahref_note"
    t.json "history_titles"
    t.bigint "host_id"
    t.index ["host_id", "crawled_at"], name: "index_pages_on_host_id_and_crawled_at"
    t.index ["host_id"], name: "index_pages_on_host_id"
    t.index ["url"], name: "index_pages_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "fname"
    t.string "lname", default: "", null: false
    t.string "postcode"
    t.boolean "admin", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "backlinks", "hosts", column: "from_id"
  add_foreign_key "backlinks", "hosts", column: "to_id"
end
