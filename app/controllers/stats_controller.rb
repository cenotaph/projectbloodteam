class StatsController < ApplicationController

  def gbp
    if params[:base_currency].nil?
      @base = 1
    else 
      @base = params[:base_currency]
    end
    @agent_blacklist = []
    params.each do |key, value|
      if key =~ /^\d*$/
        @agent_blacklist.push(key) if value == "1"
      end
    end
    @agent_blacklist = [0] if @agent_blacklist.empty?
    exchanges = Exchange.where(:basecurrency_id => @base)
    inversions = Exchange.where(:othercurrency_id => @base)
    @gbp = Hash.new
    [Activity, Bar, Brewing, Concert, Event, Gambling, Grocery, Mile, Movie, Music, Restaurant, Takeaway].each do |category|
      next if params[category.to_s] == "1"
      category.where('date >= "2002-01-01"').where("agent_id not in(?)", @agent_blacklist).group_by{|x| x.date.strftime("%Y")}.each do |year|
        @gbp[year.first] = Hash.new if @gbp[year.first].nil?
        @gbp[year.first]['Total'] = 0
        @gbp[year.first]['Rejected'] = Array.new if @gbp[year.first]['Rejected'].nil?
        @gbp[year.first][category.to_s] = Hash.new if @gbp[year.first][category.to_s].nil?
        year.last.group_by{|x| x.currency_id }.each do |i|
          @gbp[year.first][category.to_s][i.first] = i.last.sum{|x| x.cost.to_f }
        end
      end
    end
    [Book, Videogame].each do |category|
      next if params[category.to_s] == "1"
      category.where('received >= "2002-01-01"').where("agent_id not in (?)", @agent_blacklist).group_by{|x| x.date.strftime("%Y")}.each do |year|
        @gbp[year.first] = Hash.new if @gbp[year.first].nil?
        @gbp[year.first]['Total'] = 0
        @gbp[year.first]['Rejected'] = Array.new if @gbp[year.first]['Rejected'].nil?
        @gbp[year.first][category.to_s] = Hash.new if @gbp[year.first][category.to_s].nil?
        year.last.group_by{|x| x.currency_id }.each do |i|
          @gbp[year.first][category.to_s][i.first] = i.last.sum{|x| x.cost.to_f }
        end
      end
    end      
    @gbp = Hash[@gbp.sort]
    @gbp.each do |year, categories|
      categories.each do |cat_name, table|
        next if cat_name == 'Total'
        table.each do |currency_id, sum|
          if currency_id.to_s == @base.to_s
            @gbp[year]['Total'] += sum
          else
            ex = exchanges.where(:othercurrency_id => currency_id).where('sample_date = ?', year.to_s + '-12-31')
            inv = inversions.where(:basecurrency_id => currency_id).where('sample_date = ?', year.to_s + '-12-31')

            if ex.empty? && inv.empty?
              @gbp[year]['Rejected'] << currency_id
            else
              if ex.empty?
                @gbp[year]['Total'] +=  (sum * (1/inv.first.rate).to_f )
              else
                @gbp[year]['Total'] +=  (sum / ex.first.rate)
              end
            end
          end
        end
      end
    end
  end

  def index
    @top_movies = []
    @top_music = []
    @top_books = []
    @top_comments = []
    @top_restaurants = []
    @movie_cost = []
    @music_cost = []
    @book_cost = []
    @restaurant_cost = []
    @concert_cost = []
    @bar_cost = []
    @activity_cost = []
    @event_cost = []    
    @movie_cost = Movie.group(:currency_id).order('sum_cost desc').sum(:cost)
    @music_cost = Music.group(:currency_id).order('sum_cost desc').sum(:cost)
    @book_cost = Book.group(:currency_id).order('sum_cost desc').sum(:cost)
    @restaurant_cost = Restaurant.group(:currency_id).order('sum_cost desc').sum(:cost)
    @concert_cost = Concert.group(:currency_id).order('sum_cost desc').sum(:cost)
    @bar_cost = Bar.group(:currency_id).order('sum_cost desc').sum(:cost)
    @activity_cost = Activity.group(:currency_id).order('sum_cost desc').sum(:cost)
    @event_cost = Event.group(:currency_id).order('sum_cost desc').sum(:cost)
    m = Movie.limit(10).group(:master_movie_id).order('count_id desc').count('id')
    m.each do |mm|
      @top_movies << [MasterMovie.find(mm.first), mm.last]
    end
    m = Music.limit(10).group(:master_music_id).order('count_id desc').count('id')
    m.each do |mm|
      @top_music << [MasterMusic.find(mm.first), mm.last]
    end
    b = Book.limit(10).group(:master_book_id).order('count_id desc').count('id')
    b.each do |mm|
      @top_books << [MasterBook.find(mm.first), mm.last]
    end
    m = Comment.limit(10).group([:item_type, :foreign_id]).order('count_id desc').count('id')
    m.each do |mm|
      @top_comments << [mm.first.first.constantize.find(mm.first.last), mm.last]
    end
    m = Restaurant.limit(10).group(:name).order('count_id desc').count('id')
    m.each do |mm|
      @top_restaurants << [mm.first, mm.last]
    end
  end

end