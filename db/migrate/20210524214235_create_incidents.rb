class CreateIncidents < ActiveRecord::Migration[6.1]
  def change
    create_table :incidents do |t|
      t.string :cantidad
      t.references :inspection, null: false, foreign_key: true
      t.references :incident_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
