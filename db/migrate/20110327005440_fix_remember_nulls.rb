class FixRememberNulls < ActiveRecord::Migration
  def self.up
    execute('alter table agents change remember_token remember_token varchar(255)')
    execute('alter table agents change remember_token_expires_at remember_token_expires_at datetime')
  end

  def self.down
  end
end
