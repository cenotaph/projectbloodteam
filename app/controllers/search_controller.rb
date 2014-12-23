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
     
  def simple
    @items = []
    scope = []
    case params[:search_scope]
      when 'all'
        scope = [Movie, Book, Music, Concert, Event, Restaurant, Bar, Takeaway, Activity, Comment, Forum, Airport, Brewing, Eating,  Grocery, Videogame]
      when 'forums'
        scope = [Forum, Comment]
      else
        scope = [Movie, Book, Music, Concert, Event, Restaurant, Bar, Takeaway, Activity, Airport, Brewing, Eating,  Grocery,   Videogame]
    end
    
    for cat in scope do
      hits =  cat.search(ThinkingSphinx::Query.escape(params[:search]), :per_page => 999)
      unless hits.empty?
        hits.each do |hit|
          if params[:search_scope] =~ /^\d+$/
            next if hit.agent_id.to_s != params[:search_scope]
          elsif params[:search_scope] == 'forums'
            if hit.class == Comment
              next unless hit.item_type == 'Forum'
            end
          end
          @items << hit
        end
      end
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
