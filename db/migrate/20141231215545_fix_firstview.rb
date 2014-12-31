class FixFirstview < ActiveRecord::Migration
  def change
    execute(" update views set movie_first = '0' where movie_first is null")
    execute("alter table views change movie_first movie_first varchar(255) not null default 'First'")
    execute("update views set movie_first = 'First' where movie_first = ''")
  end
end
