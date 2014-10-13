class CreateScfReports < ActiveRecord::Migration
  def change
    create_table :scf_reports do |t|
      t.integer   :external_api_id
      t.text      :external_api_hash
      t.datetime  :external_api_updated_at
      t.datetime  :external_api_checked_at
      t.boolean   :processed, default: false, null: false
      t.boolean   :should_create_incident, default: true, null: true
      t.text      :source
     
      t.boolean   :is_acknowledged
      t.datetime  :acknowledged_at
      t.boolean   :is_closed
      t.datetime  :closed_at

      t.timestamps
    end
  end
end
