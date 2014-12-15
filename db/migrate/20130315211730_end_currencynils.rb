class EndCurrencynils < ActiveRecord::Migration
  def self.up

    profiles = Hash.new
    Profile.all.each do |prof|
      profiles[prof.agent_id] = Hash.new if profiles[prof.agent_id].nil?
      profiles[prof.agent_id][prof.year] = prof.defaultcurrency_id if profiles[prof.agent_id][prof.year].nil?
    end
    [Activity, Bar, Book, Brewing, Concert, Event, Gambling, Grocery, Mile, Movie, Music, Restaurant, Takeaway, Videogame].each do |category|
      nils = category.where(:currency_id => nil)
      nils.each do |missing_currency|
        if profiles[missing_currency.agent_id][missing_currency.date.strftime('%Y').to_i].nil?
          puts "Don't have default for " + missing_currency.agent_id.to_s +  " and year " + missing_currency.date.strftime('%Y').to_s
          missing_currency.update_attribute('currency_id', 1)
        else
          missing_currency.update_attribute('currency_id', profiles[missing_currency.agent_id][missing_currency.date.strftime('%Y').to_i])
        end
      end
    end
  end

  def self.down
  end
end
