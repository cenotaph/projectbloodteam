class AddDeltasToTvseries < ActiveRecord::Migration[5.0]
  def change
    add_column :tvseries, :delta, :boolean, :default => true,
    :null => false
    execute('UPDATE activities SET delta=1 WHERE delta is null')
    execute('UPDATE airports SET delta=1 WHERE delta is null')
    execute('UPDATE bars SET delta=1 WHERE delta is null')
    execute('UPDATE books SET delta=1 WHERE delta is null')
    execute('UPDATE brewing SET delta=1 WHERE delta is null')
    execute('UPDATE comments SET delta=1 WHERE delta is null')
    execute('UPDATE concerts SET delta=1 WHERE delta is null')
    execute('UPDATE events SET delta=1 WHERE delta is null')
    execute('UPDATE forums SET delta=1 WHERE delta is null')
    execute('UPDATE groceries SET delta=1 WHERE delta is null')
    execute('UPDATE miles SET delta=1 WHERE delta is null')
    execute('UPDATE musicplayed SET delta=1 WHERE delta is null')
    execute('UPDATE restaurants SET delta=1 WHERE delta is null')
    execute('UPDATE takeaway SET delta=1 WHERE delta is null')
    execute('UPDATE videogames SET delta=1 WHERE delta is null')
    
  end
end
