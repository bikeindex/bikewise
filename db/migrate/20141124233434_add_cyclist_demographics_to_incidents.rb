class AddCyclistDemographicsToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :experience_level, :integer
    add_column :incidents, :age, :integer
    add_column :incidents, :name, :text
    add_column :incidents, :gender, :string
  end
end
