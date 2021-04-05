class CreateEmailTable < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :email
      t.references :page
      t.timestamps
    end
  end
end
