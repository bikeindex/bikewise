class CreateIncidentTypes < ActiveRecord::Migration
  def change
    create_table :incident_types do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :incidents, :incident_type_id
  end
end
