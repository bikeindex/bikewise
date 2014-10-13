class CreateIncidentReports < ActiveRecord::Migration
  def change
    create_table :incident_reports do |t|
      t.integer :incident_id
      t.references :report, polymorphic: true
      t.boolean :is_open311_report
      t.boolean :is_incident_source
      
      t.timestamps
    end
    add_index :incident_reports, [:report_id, :report_type]
  end
end
