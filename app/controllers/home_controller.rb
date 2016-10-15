# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  before_action :login_required, :only => [:missing_profile]
    
  def index
    # @random_agents = Profile.where(:year => getYear).includes(:agent).sort_by {|x| x.agent.lastlogin }.reverse[0..11]
    #
    # # get today's date
    # if params[:page].nil?
    #   page = 1
    # else
    #   page = params[:page]
    # end

    # @on_this_day = []
    # categories = [Movie, Music, Book, Restaurant, Concert, Activity, Bar, Airport, Brewing, Event, Videogame, Musicplayed, Takeaway].sort_by{ rand }
    #   while @on_this_day.size < 15  && !categories.empty?
    #         the_cat = categories.pop
    #         if the_cat != Book && the_cat != Videogame
    #           ids = the_cat.connection.select_all("SELECT id FROM #{the_cat.to_s.tableize} WHERE date LIKE \"%#{Time.now.strftime('-%m-%d')}\" AND date != \"#{Time.now.strftime('%Y-%m-%d')}\"" )
    #         else
    #           ids = the_cat.connection.select_all("SELECT id FROM #{the_cat.to_s.tableize} WHERE received LIKE \"%#{Time.now.strftime('-%m-%d')}\" OR started LIKE \"%#{Time.now.strftime('-%m-%d')}\" OR finished LIKE \"%#{Time.now.strftime('-%m-%d')}\" AND received != \"#{Time.now.strftime('%Y-%m-%d')}\"  AND started != \"#{Time.now.strftime('%Y-%m-%d')}\"  AND finished != \"#{Time.now.strftime('%Y-%m-%d')}\"")
    #         end
    #         @on_this_day << the_cat.find(ids[rand(ids.count)]["id"].to_i) unless ids.blank?
    #         if !agent_signed_in?
    #           @on_this_day.delete_if{|x| x.agent.security > 1 }
    #         end
    #         @on_this_day.uniq!
    #       end
    #
    @json = Entry.includes([{:entry => {:geolocation => [
                                                          {:bars => :agent}, {:concerts => :agent},
                                                          {:movies => [:master_movie, :agent]},
                                                           {:takeaways => :agent}, {:restaurants => :agent},
                                                           {:events => :agent}, {:activities => :agent}, {:tvseries => :agent}
                                                        ]
                                        }
                              } ]
        ).where("entry_type not in (?)", ['Music', 'Book', 'Mile', 'Eating', 'Exercise', 'Comment', 'Forum', 'Airport', 'Videogame']).order('created_at DESC').limit(50).to_a.delete_if{|x| !x.entry.respond_to?('geolocation')}.map{|x| x.entry.geolocation}.compact.uniq
        


    if agent_signed_in?
      if current_agent.profile.nil?
        missing_profile
        return
      end
      @newsfeed = Entry.includes([:agent, {:entry => [:agent]}]).group([:created_at, :entry_type, :entry_id, :action]).where('created_at <= "' + getYear + '-12-31 23:59:59"').order('created_at DESC').page(params[:page]).per(12) #, :total_entries => Entry.find(:all, :group => [:entry_type, :entry_id]).size  ) 
    else
      @newsfeed = Entry.joins(:agent).group([:created_at, :entry_type, :entry_id, :action]).where('agents.security = 0').order('created_at DESC').page(params[:page]).per(12) # , :total_entries => Entry.find(:all, :include => :agent,  :conditions => 'agents.security = 0', :group => [:entry_type, :entry_id]).size  ) 
    end
    set_meta_tags :title => 'Home'
    
  end
  
  def missing_profile
    check_first = Profile.where(:agent_id => current_agent.id).where(:year => getYear)
    if check_first.empty?
      @profile = Profile.new(:agent => current_agent, :year => getYear)
      @profile.surname = current_agent.surname
      @profile.age = current_agent.age
      @profile.missionname = current_agent.missionname
      @profile.defaultcurrency_id = Currency.where(:symbol => current_agent.defaultcurrency).first.id
      set_meta_tags :title => 'New profile for ' + getYear.to_s
      render :template => 'shared/profiles/new'
    else
      flash[:error] = 'You already have a profile for this year.'
      redirect_to '/'
    end
  end
  
end
