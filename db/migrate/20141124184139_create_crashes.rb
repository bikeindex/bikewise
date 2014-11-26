class CreateCrashes < ActiveRecord::Migration
  def change
    create_table :crashes do |t|
      t.integer :location_select_id
      t.boolean :rain
      t.boolean :snow
      t.boolean :fog
      t.boolean :wind
      t.boolean :lights
      t.boolean :helmet
      t.integer :injury_severity_select_id
      t.integer :lighting_select_id
      t.integer :visibility_select_id

      t.integer :condition_select_id
      t.integer :geometry_select_id
      t.text :conditions_description

      t.text :injury_description
      t.integer :crash_select_id

      t.integer :vehicle_select_id

      t.timestamps
    end
    add_index :crashes, :location_select_id
    add_index :crashes, :geometry_select_id
    add_index :crashes, :condition_select_id
    add_index :crashes, :crash_select_id
    add_index :crashes, :vehicle_select_id
    add_index :crashes, :injury_severity_select_id
    add_index :crashes, :lighting_select_id
    add_index :crashes, :visibility_select_id
  end
end
