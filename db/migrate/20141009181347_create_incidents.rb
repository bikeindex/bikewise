class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|      
      t.integer   :incident_type_id
      t.string    :address
      t.integer   :country_id
      t.float     :latitude
      t.float     :longitude
      
      t.string    :image_url
      t.string    :image_url_thumb

      t.text      :title
      t.text      :description
      t.string    :type_name

      t.datetime  :occurred_at

      t.boolean   :create_open311_report, default: false, null: false
      t.boolean   :has_open311_report, default: false, null: false
      t.boolean   :open311_is_acknowledged
      t.boolean   :open311_is_closed

      t.timestamps
    end
    add_index :incidents, [:latitude, :longitude]
  end
end
