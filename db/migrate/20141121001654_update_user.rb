class UpdateUser < ActiveRecord::Migration
  def change
    remove_column :users, :uid, :text 
    remove_column :users, :provider, :string
    remove_column :users, :access_token, :text
    add_column :users, :experience_level, :integer
    add_column :users, :birth_year, :integer
    add_column :users, :name, :text
    add_column :users, :gender, :string
  end
end
