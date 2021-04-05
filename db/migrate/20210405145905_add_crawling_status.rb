class AddCrawlingStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :hosts, :page_crawled_at, :datetime, default: nil
    add_column :hosts, :linked_hosts_crawled_at, :datetime, default: nil
  end
end
