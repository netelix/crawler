class AddRedirection < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :redirect_to, :string
  end
end
