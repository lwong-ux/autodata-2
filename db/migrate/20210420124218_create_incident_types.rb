class CreateIncidentTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :incident_types do |t|
      t.string :tipo

      t.timestamps
    end
  end
end
