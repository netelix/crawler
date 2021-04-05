class CreateHostTable < ActiveRecord::Migration[5.2]
  def change
    create_table :hosts do |t|
      t.string "host"
      t.string "domain_status"
      t.string "majestic_trust_flow"
      t.string "majestic_citation_flow"
      t.string "ahref_note"
      t.json "history_titles"
      t.index ["host"], name: "index_pages_on_host", unique: true
      t.timestamps
    end

    add_reference :pages, :host
  end
end
