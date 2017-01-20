# -*- encoding : utf-8 -*-
class SearchController < ApplicationController

  def advanced
      @hits = []
      for cat in [Movie, Book, Music, Concert, Event, Restaurant, Bar, Takeaway, Activity,  Mile,  Weight, Loan] do
        if params[:onecat]
          if params[:onecat] != cat.to_s
            next
          end
        end
          @hits = @hits + cat.search(params[:search], :per_page => :all)
      end
      if params[:oneagent]
          @hits.delete_if{|x| x.agent_id.to_s != params[:oneagent]}
      end
      @searchterm = params[:search]
      render :layout => getTheme(params[:oneagent] ? params[:oneagent] : params[:id], getYear), :template => getTheme(params[:id], getYear) + '/searchresults'
  end
     
  def by_category
    @items = Hash.new
    @totals = Hash.new
    @map = []
    cat = params[:id]
    @searchterm = params[:search]
    @items[cat] =  cat.constantize.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 25, page: params[:page])
    @totals[cat] = @items[cat].total_entries
    unless @items[cat.to_s].empty?
      @items[cat.to_s].each do |hit|
        if hit.respond_to?(:geolocation)
          unless hit.geolocation.nil?
            @map.push hit.geolocation
          end
        end
      end
    end
    set_meta_tags :title => "Search: #{@searchterm}"
    render :template => 'shared/search_results'
  end
  
  def simple
    @items = Hash.new
    @totals = Hash.new
    @map = []
    scope = []
    case params[:search_scope]
      when 'all'
        scope = [Movie, Book, Music, Concert, Tvseries, Event, Restaurant, Bar, Takeaway, Activity, Comment, Forum, Airport, Brewing, Eating,  Grocery, Videogame]
      when 'forums'
        scope = [Forum, Comment]
      else
        scope = [Movie, Book, Music, Concert, Tvseries, Event, Restaurant, Bar, Takeaway, Activity, Airport, Brewing, Eating,  Grocery,   Videogame]
    end
    
    # @movies = Movie.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @books = Book.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @music = Music.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @concerts = Concerts.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @events = Event.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @restaurants = Restaurant.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 4
    # @bar = Bar.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @takeaway = Takeaway.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @activities = Activity.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @airports = Airport.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @brewing = Brewing.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @groceries = Grocery.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    # @videogames = Videogame.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 40)
    
    for cat in scope do
      @items[cat.to_s] = cat.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 25)
      @totals[cat.to_s] = @items[cat.to_s].total_entries
      unless @items[cat.to_s].empty?
        @items[cat.to_s].each do |hit|
          if hit.respond_to?(:geolocation)
            unless hit.geolocation.nil?
              @map.push hit.geolocation
            end
          end
        end
      end
#           if params[:search_scope] =~ /^\d+$/
#             next if hit.agent_id.to_s != params[:search_scope]
#           elsif params[:search_scope] == 'forums'
#             if hit.class == Comment
#               next unless hit.item_type == 'Forum'
#             end
#           end
#           @items[cat.to_s] << hit
#         end
#       end
    end
    

    unless params[:userfilter].blank?
      if params[:userfilter] != '0'
        @items.delete_if {|x| x.agent_id != params[:userfilter].to_i }
      end
    end

    @items.compact!
    @searchterm = params[:search]
    set_meta_tags :title => "Search: #{@searchterm}"
    render :template => 'shared/search_results'
  end
  
end
