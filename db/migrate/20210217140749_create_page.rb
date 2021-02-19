class CreatePage < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.string :url
      t.string :title
      t.datetime :crawled_at
      t.json :emails
      t.json :phones
      t.json :postcodes
    end

    add_index :pages, :url, unique: true
  end
end
