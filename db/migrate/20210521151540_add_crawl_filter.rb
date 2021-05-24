class AddCrawlFilter < ActiveRecord::Migration[5.2]
  def change
    add_column :hosts, :filter, :text
  end
end
