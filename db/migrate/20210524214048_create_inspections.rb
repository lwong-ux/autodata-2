class CreateInspections < ActiveRecord::Migration[6.1]
  def change
    create_table :inspections do |t|
      t.integer :num_item
      t.string :lote
      t.string :lote_prod1
      t.string :lote_prod2
      t.integer :inspecciones
      t.integer :ok
      t.integer :ng
      t.integer :recuperadas
      t.integer :scrap
      t.integer :incidentes
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
