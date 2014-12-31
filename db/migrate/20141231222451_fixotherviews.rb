class Fixotherviews < ActiveRecord::Migration
  def change
    execute("update views set movie_location = '0' where movie_location is null");
    execute('alter table views change movie_location movie_location varchar(255) not null default "Location"')
    execute("update views set book_first = '0' where book_first is null")
    execute('alter table views change book_first book_first varchar(255) not null default "First reading?"')
  end
end
