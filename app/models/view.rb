# -*- encoding : utf-8 -*-
class View < ActiveRecord::Base
  belongs_to :agent
  
  def agent_column_name(item, column)
    if self.respond_to?(item.class.to_s.downcase + "_" + column)
      if self.method(item.class.to_s.downcase + "_" + column).call == "0"
        return nil
      else
        if self.method(item.class.to_s.downcase + "_" + column).call == ""
          return column
        else
          return self.method(item.class.to_s.downcase + "_" + column).call
        end
      end
    else
      return (column == 'first' ? 'First?' : column)
    end

  end
  
  def columns_for_category(category, is_new = false)
    out = []
    category.columns.each do |x|
      next if x.name =~ /_id$/
      next if x.name == 'id'
      next if x.name =~ /_at$/
      next if x.name =~ /is_short$/
      # next if x.name == 'venue_address'
      next if x.name == 'delta'
      next if x.name == 'userimage'
      full = category.to_s.downcase + "_" + x.name
      if self[full.to_sym] != "0"
        out.push(x.name)
      end
    end
    if category.has_master? && is_new == false
      if category == Book
        category.master_cols.each{|x| out.insert(3, x) }
      elsif category == Tvseries
        category.master_cols.each{|x| out.insert(2, x) }
      else
        category.master_cols.each{|x| out.insert(1, x) }
      end
    end
    return out
  end
  
  def hasmovie_started
  return true if self.movie_started != '0'
  end

  def hasmovie_format
  return true if self.movie_format != '0'
  end

  def hasloan_comment
    return true if self.loan_comment != '0'
  end
  
  def hasmovie_company
  return true if self.movie_company != '0'
  end


  def hasmovie_cost
  return true if self.movie_cost != '0'
  end

  def hasmiles_cost
    return true if self.miles_cost != '0'
  end



  def hasmovie_rating
  return true if self.movie_rating != '0'
  end


  def hasmovie_comment
  return true if self.movie_comment != '0'
  end


  def hasmovie_first
  return true if self.movie_first != '0'
  end


  def hasmusic_source
  return true if self.music_source != '0'
  end


  def hasmusic_cost
  return true if self.music_cost != '0'
  end


  def hasmusic_rating
  return true if self.music_rating != '0'
  end


  def hasmusic_comment
  return true if self.music_comment != '0'
  end


  def hasmusic_received
  return true if self.music_received != '0'
  end


  def hasmusic_procurement
  return true if self.music_procurement != '0'
  end


  def hasbook_source
  return true if self.book_source != '0'
  end


  def hasbook_difficulty
  return true if self.book_difficulty != '0'
  end


  def hasbook_pagecount
    return true if self.book_pagecount != '0'
  end


  def hasbook_cost
    return true if self.book_cost != '0'
  end

  def hasairport_comment
      return true if self.airport_comment != '0'
  end
  
  def hasairport_time_spent
      return true if self.airport_time_spent != '0'
  end
  
  def hasbook_rating
    return true if self.book_rating != '0'
  end


  def hasbook_comment
    return true if self.book_comment != '0'
  end


  def hasconcert_cost
  return true if self.concert_cost != '0'
  end


  def hasconcert_rating
  return true if self.concert_rating != '0'
  end


  def hasconcert_company
  return true if self.concert_company != '0'
  end


  def hasconcert_comment
  return true if self.concert_comment != '0'
  end


  def hasevent_cost
  return true if self.event_cost != '0'
  end


  def hasevent_rating
  return true if self.event_rating != '0'
  end


  def hasevent_company
  return true if self.event_company != '0'
  end


  def hasevent_comment
  return true if self.event_comment != '0'
  end


  def hasrestaurant_cost
  return true if self.restaurant_cost != '0'
  end


  def hasrestaurant_cuisine
  return true if self.restaurant_cuisine != '0'
  end


  def hasrestaurant_rating
  return true if self.restaurant_rating != '0'
  end


  def hasrestaurant_comment
  return true if self.restaurant_comment != '0'
  end


  def hasrestaurant_company
  return true if self.restaurant_company != '0'
  end


  def hasbar_cost
  return true if self.bar_cost != '0'
  end


  def hasbar_rating
  return true if self.bar_rating != '0'
  end


  def hasbar_company
  return true if self.bar_company != '0'
  end


  def hasbar_comment
  return true if self.bar_comment != '0'
  end


  def hastakeaway_cost
  return true if self.takeaway_cost != '0'
  end


  def hastakeaway_rating
  return true if self.takeaway_rating != '0'
  end


  def hastakeaway_company
  return true if self.takeaway_company != '0'
  end


  def hastakeaway_comment
  return true if self.takeaway_comment != '0'
  end


  def hasmovie_location
    return true if self.movie_location != '0'
  end

  def hasmiles_location
    return true if self.miles_location != '0'
  end

  def hasmusic_isnew
  return true if self.music_isnew != '0'
  end


  def hasbook_first
  return true if self.book_first != '0'
  end


  def hasactivity_company
  return true if self.activity_company != '0'
  end


  def hasactivity_cost
  return true if self.activity_cost != '0'
  end


  def hasactivity_rating
  return true if self.activity_rating != '0'
  end


  def hasactivity_comment
  return true if self.activity_comment != '0'
  end


  def hasweight_comment
  return true if self.weight_comment != '0'
  end

  def hasproject_name
    return true if self.project_name != '0'
  end
  
  def hasproject_materials
    return true if self.project_materials != '0'
  end
  
  def hasproject_tools
    return true if self.project_tools != '0'
  end
  
  def hasproject_collaborators
    return true if self.project_collaborators != '0'
  end
  
  def hasproject_format
    return true if self.project_format != '0'
  end
  
  def hasproject_comment
    return true if self.project_comment != '0'
  end
  
  def hasvideogame_comment
    return true if self.videogame_comment != '0'
  end
  
  def hasvideogame_difficulty
    return true if self.videogame_difficulty != '0'
  end
  
  def hasvideogame_cost
    return true if self.videogame_cost != '0'
  end
  
  def hasvideogame_rating
    return true if self.videogame_rating != '0'
  end
  
  def hasvideogame_source
    return true if self.videogame_source != '0'
  end
  
  def hasvideogame_soldprice
    return true if self.videogame_soldprice != '0'
  end
  
  def hasbrewing_cost
    return true if self.brewing_cost != '0'
  end
  
  def hasgrocery_comment
    return true if self.grocery_comment != '0'
  end
  
  def hasgrocery_cost
    return true if self.grocery_cost != '0'
  end
  
  
  def hasgrocery_clubsavings
    return true if self.grocery_cost != '0'
  end
  
  
  def hasgrocery_coupons
    return true if self.grocery_cost != '0'
  end
  
  def hastvseries_rating
    return true if self.tvseries_rating != '0'
  end
  
  def hastvseries_comment
    return true if self.tvseries_comment != '0'
  end

  def hasmiles_gasamount
    return true if self.miles_gasamount != '0'
  end
  def hasmiles_miles
    return true if self.miles_miles != '0'
  end
  def hasmiles_ppg
    return true if self.miles_ppg != '0'
  end
  def hasmiles_station
    return true if self.miles_station != '0'
  end
    
end
