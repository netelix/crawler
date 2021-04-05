class CreateLinkedByHosts < ActiveRecord::Migration[5.2]
  def change
    create_table :backlinks do |t|
      t.references :from, index: true, foreign_key: {to_table: :hosts}
      t.references :to, index: true, foreign_key: {to_table: :hosts}
    end
  end
end
