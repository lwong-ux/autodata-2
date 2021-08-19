class CreateQuotations < ActiveRecord::Migration[6.1]
  def change
    create_table :quotations do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.string :orden_compra
      t.date :fecha_orden
      t.date :fecha_cotizada
      t.string :modo_cobro
      t.decimal :precio
      t.decimal :sub_total
      t.decimal :iva
      t.decimal :total

      t.timestamps
    end
  end
end
