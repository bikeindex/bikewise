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
      t.integer :lighting
      t.integer :visibility

      t.integer :condition_select_id
      t.text :conditions_description

      t.integer :injury_severity
      t.text :injury_description
      t.integer :crash_select_id

      t.integer :vehicle_select_id


      t.timestamps
    end
    add_index :crashes, :location_select_id
    add_index :crashes, :condition_select_id
    add_index :crashes, :crash_select_id
    add_index :crashes, :vehicle_select_id
  end
end
