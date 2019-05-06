class SwitchIncidentImageUrlsToBeText < ActiveRecord::Migration
  def change
    change_column :incidents, :image_url, :text
    change_column :incidents, :image_url_thumb, :text
  end
end
