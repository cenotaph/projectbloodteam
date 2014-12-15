# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  belongs_to :agent
  scope :year, -> (y)  { where(year: y) }
  
  attr_accessor :has_movies, :has_musics, :has_books, :has_activities, :has_airports, :has_brewing, :has_concerts, :has_eating, :has_events, :has_exercise, :has_gambling, :has_groceries, :has_miles, :has_musicplayed, :has_restaurants, :has_takeaway, :has_bars, :has_weight, :has_videogames
  
  def forums
    "Forum"
  end
  
end
