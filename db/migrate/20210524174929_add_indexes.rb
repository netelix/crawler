class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :pages, [:host_id, :crawled_at]
    add_index :hosts, [:domain_status]
  end
end
