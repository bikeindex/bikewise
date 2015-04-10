class AddOccurredAtStampToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :occurred_at_stamp, :integer
  end
end
