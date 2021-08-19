class AddCantidadToIncidents < ActiveRecord::Migration[6.1]
  def change
    add_column :incidents, :cantidad, :integer
  end
end
