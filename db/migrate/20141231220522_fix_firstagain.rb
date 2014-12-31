class FixFirstagain < ActiveRecord::Migration
  def change
    execute("alter table views change movie_first movie_first varchar(255) not null default 'First?'")
  end
end
