class CreateThefts < ActiveRecord::Migration
  def change
    create_table :thefts do |t|
      t.integer :locking_select_id
      t.integer :locking_defeat_select_id
      t.boolean :has_police_report

      t.timestamps
    end
    add_index :thefts, :locking_select_id
    add_index :thefts, :locking_defeat_select_id
  end
end
