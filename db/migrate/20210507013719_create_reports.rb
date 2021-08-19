class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :turno
      t.datetime :fecha_inicio
      t.datetime :fecha_termino
      t.integer :total_inspeccion
      t.integer :total_ok
      t.integer :total_ng
      t.integer :total_recupera
      t.integer :total_basura
      t.integer :total_incidentes
      t.references :quotation, null: false, foreign_key: true
      t.boolean :capturando

      t.timestamps
    end
  end
end
