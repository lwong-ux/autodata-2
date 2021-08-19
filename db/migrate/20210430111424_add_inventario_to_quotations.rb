class AddInventarioToQuotations < ActiveRecord::Migration[6.1]
  def change
    add_column :quotations, :inventario, :decimal
  end
end
