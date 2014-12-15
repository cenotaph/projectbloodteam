load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

require 'erb'

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    development:
      adapter: mysql
      database: pbt3_production
      username: root
      password: dgmf49h
      socket: /var/run/mysqld/mysqld.sock
      pool: 5
      timeout: 5000
    production:
      adapter: mysql
      database: pbt3_production
      username: root
      password: dgmf49h
      socket: /var/run/mysqld/mysqld.sock
      pool: 5
      timeout: 5000
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -s #{shared_path}/images #{release_path}/public/"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -sf #{shared_path}/db/sphinx #{latest_release}/db/sphinx"
    run "cp #{shared_path}/production.sphinx.conf #{latest_release}/config/"
  end
end

