class CreateParts < ActiveRecord::Migration[6.1]
  def change
    create_table :parts do |t|
      t.string :num_parte
      t.string :nombre
      t.references :plant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
