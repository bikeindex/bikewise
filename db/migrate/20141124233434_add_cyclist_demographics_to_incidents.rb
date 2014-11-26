class AddCyclistDemographicsToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :experience_level_select_id, :integer
    add_column :incidents, :age, :integer
    add_column :incidents, :name, :text
    add_column :incidents, :gender_select_id, :integer
    add_index :incidents, :experience_level_select_id
    add_index :incidents, :gender_select_id
  end
end
