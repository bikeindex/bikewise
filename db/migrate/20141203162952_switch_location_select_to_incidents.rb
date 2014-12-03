class SwitchLocationSelectToIncidents < ActiveRecord::Migration
  def change
    remove_column :crashes, :location_select_id, :integer
    remove_column :hazards, :location_description, :string
    add_column :incidents, :location_description, :text
    add_column :incidents, :location_select_id, :integer
  end
end
