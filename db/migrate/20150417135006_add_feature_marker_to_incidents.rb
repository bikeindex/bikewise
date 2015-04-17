class AddFeatureMarkerToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :feature_marker, :json
  end
end
