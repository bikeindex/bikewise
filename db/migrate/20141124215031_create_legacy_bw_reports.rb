class CreateLegacyBwReports < ActiveRecord::Migration
  def change
    create_table :legacy_bw_reports do |t|
      t.string    :external_api_id
      t.text      :external_api_hash
      t.datetime  :external_api_updated_at
      t.datetime  :external_api_checked_at
      t.boolean   :processed, default: false, null: false
      t.boolean   :should_create_incident, default: true, null: true
      t.text      :source
      t.integer   :legacy_bw_user_id


      t.timestamps
    end
  end
end
