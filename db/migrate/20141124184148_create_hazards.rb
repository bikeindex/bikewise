class CreateHazards < ActiveRecord::Migration
  def change
    create_table :hazards do |t|
      t.string :location_description
      t.integer :hazard_select_id
      t.integer :priority

      t.timestamps
    end
    add_index :hazards, :hazard_select_id
  end
end
