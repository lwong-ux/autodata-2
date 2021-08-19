class CreatePlants < ActiveRecord::Migration[6.1]
  def change
    create_table :plants do |t|
      t.string :nombre
      t.string :contacto
      t.string :tel
      t.string :direccion
      t.string :entidad

      t.timestamps
    end
  end
end
