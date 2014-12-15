class ConvertRaToDevise < ActiveRecord::Migration
  def self.up

    #encrypting passwords and authentication related fields
    rename_column :agents, "password", "encrypted_password"
    change_column :agents, "encrypted_password", :string, :limit => 128, :default => "", :null => false
    # rename_column :agents, "salt", "password_salt"
    add_column :agents, "password_salt", :string, :default => "", :null => false


    #reset password related fields
    add_column :agents, "reset_password_token", :string
    add_column :agents, "reset_password_sent_at", :datetime

    #rememberme related fields
    rename_column :agents, "remember_token_expires_at", "remember_created_at"

  end

  def self.down

    #rememberme related fields
    rename_column :agents, "remember_created_at", "remember_token_expires_at"
    remove_column :agents, "reset_password_sent_at"
    #reset password related fields
    remove_column :agents, "reset_password_token"


    #encrypting passwords and authentication related fields
    rename_column :agents, "encrypted_password", "password"
    change_column :agents, "password", :string, :limit => 40
    remove_column :agents, "password_salt"


  end
end
