class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string   :image
      t.string   :name
      t.integer  :incident_id

      t.timestamps
    end
  end
end
