class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :binx_id

      t.text :binx_bike_ids

      t.text :additional_emails
      t.text :email_confirmation_token
      
      # Omniauth
      t.string :provider
      t.text  :uid

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.boolean  :admin, default: false, null: false
      t.text :access_token

      t.timestamps
    end

    add_column :incidents, :user_id, :integer
    add_index :incidents, :user_id
  end
end
