class RenamePriorityToPrioritySelect < ActiveRecord::Migration
  def change
    rename_column :hazards, :priority, :priority_select_id
  end
end
