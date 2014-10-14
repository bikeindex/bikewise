class AddSourcesToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :source_type, :string
    add_column :incidents, :source, :text
    add_column :incidents, :additional_sources, :text
    remove_column :binx_reports, :source, :text
    remove_column :scf_reports, :source, :text
    remove_column :bw_reports, :source, :text
  end
end
