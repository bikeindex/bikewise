class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iso
      
      t.timestamps
    end
    add_index :incidents, :country_id
  end
end
