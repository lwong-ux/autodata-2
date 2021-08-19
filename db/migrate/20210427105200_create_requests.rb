class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.string :serie
      t.string :lote
      t.integer :inventario
      t.references :incident_type, null: false, foreign_key: true
      t.string :ayuda_visual
      t.string :metodo
      t.string :consumo

      t.timestamps
    end
  end
end
