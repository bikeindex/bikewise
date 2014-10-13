class CreateImportStatuses < ActiveRecord::Migration
  def change
    create_table :import_statuses do |t|
      t.string :source 
      t.datetime :checked_updates_at
      t.text :info_hash

      t.timestamps
    end
  end
end
