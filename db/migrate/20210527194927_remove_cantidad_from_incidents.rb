class RemoveCantidadFromIncidents < ActiveRecord::Migration[6.1]
  def change
    remove_column :incidents, :cantidad, :string
  end
end
