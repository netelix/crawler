class AddDomainFields < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :domain_status, :string
    add_column :pages, :majestic_trust_flow, :string
    add_column :pages, :majestic_citation_flow, :string
    add_column :pages, :ahref_note, :string
    add_column :pages, :history_titles, :json
  end
end
