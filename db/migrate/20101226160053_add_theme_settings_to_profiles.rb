class AddThemeSettingsToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :theme_settings, :text
    execute('alter table profiles change imageurl imageurl varchar(255) ')
  end

  def self.down
    remove_column :profiles, :theme_settings
  end
end
