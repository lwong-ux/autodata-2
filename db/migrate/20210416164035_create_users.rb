class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :p_apellido
      t.string :s_apellido
      t.string :tel
      t.string :email
      t.integer :permiso
      t.string :usuario
      t.string :clave
      t.boolean :conectado
      t.date :ultima_fecha
      t.time :ultima_hora
      t.integer :duracion
      t.date :conexion_fecha
      t.time :conexion_hora
      t.references :cliente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
