class AddFieldsToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :host, :string
    add_column :pages, :error, :string
    add_column :pages, :backlink_hosts, :json
  end
end
