class AddLegacyBwHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legacy_bw_hash, :text
    add_column :users, :legacy_bw_id, :integer
    add_column :users, :experience_level_select_id, :integer
    add_column :users, :gender_select_id, :integer
    remove_column :users, :experience_level, :integer
    remove_column :users, :additional_emails, :text
  end
end
