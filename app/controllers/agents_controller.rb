# -*- encoding : utf-8 -*-
class AgentsController < ApplicationController
  respond_to :html, :rss
  before_filter :authenticate_agent!, :only => [:your_settings, :edit, :update]
  
  
  def change_password 
    if params[:orig_password].nil?
      render :layout => getTheme(current_agent.id, getYear)
    else
      if Agent.authenticate(current_agent.username, params[:orig_password])
        if params[:password] == params[:password_confirmation]
          current_agent.password = Digest::MD5.hexdigest(params[:password])
          if current_agent.save 
            flash[:notice] = 'Password is changed.'
            redirect_to '/settings/'
          else
            flash[:notice] = 'Error saving password in model.'
          end
        else
          flash[:notice] = 'Password do not match.'
        end
      else 
        flash[:notice] = 'Incorrect old password.'
      end
    end
  end
  
  def create 
    @agent = Agent.new(agent_params)
    if params[:new_user_password] = 'norman_reedus'
      if @agent.save
        flash[:error] = 'Welcome to PBT! Please log in to complete your registration'
        redirect_to '/'
      else
        flash[:error] = @agent.errors.full_messages.join(', ')
        render :template => 'agents/new'
      end
    else
      flash[:error] = 'Incorrect new user password, sorry.'
      render :template => 'agents/new'
    end
  end
  
  def new
    @agent = Agent.new
    set_meta_tags title: 'New agent registration'
  end
  
  def edit
    @agent = Agent.friendly.find(params[:id])
    if current_agent == @agent
      @agent.twitpasswd = @agent.twitpasswd.tr("A-Ma-mN-Zn-z","N-Zn-zA-Ma-m") if @agent.twitpasswd
    else
     flash[:notice] = 'You cannot edit another agent\'s profile.'
     redirect_to '/settings/'
    end
    set_meta_tags :title => 'Editing your details'
  end

  def history
    @agent = Agent.find(params[:id])
    @history = Hash.new
    @current_year = Time.now.strftime('%Y').to_i
    [Movie, Book, Music, Concert, Event, Restaurant, Bar, Takeaway, Activity, Airport, Brewing, Eating, Gambling, Grocery, Mile, Musicplayed, Videogame].each do |category|
      if @history[category.to_s].nil?
        @history[category.to_s] = Hash.new 
        (2002..@current_year).each do |year|
          @history[category.to_s][year] = 0
        end
      end
      records = category.where(:agent_id => params[:id]).group_by{|x| x.date.strftime('%Y') }.map{|year, entries| {year => entries.count} }
      records.each do |hash|
        @history[category.to_s][hash.keys.first.to_i] = hash.values.first
      end
      @href = []
      @history.each do |category|
        category.last.each do |year, amt|
          if amt == 0
            @href.push("")
          else
            @href.push("http://#{year.to_s}.bloodteam.com/agents/#{params[:id]}/#{category.first.tableize}")
          end
        end
      end
      @history
      @data = @history.map{|x| x.last.values}.flatten 
    end
    # exit
  end

  
  def index
    if params[:id].nil?
      redirect_to '/'
    else
      @agent = Agent.find(params[:id])
      respond_with(@agent)
    end
  end

  def rss
    @agent = Agent.find(params[:id])
    if @agent.security > 0
      if params[:password] == Agent.find(params[:id]).public_password
        @logged_in  = true
      end
    else
        @logged_in = true
    end

    @feed = []
    for cat in [Movie, Music, Concert, Event, Restaurant, Bar, Takeaway, Activity, Gambling, Mile, Eating, Weight, Brewing, Grocery, Exercise] do
      @feed += cat.where(:agent => @agent).limit(55).order("date DESC")
    end
    vg = Videogame.where(:agent => @agent).select("*, updated_at AS date").limit(55).order('finished DESC, started DESC, received DESC')
    vg.each_index do |i|
      begin
        vg[i].date = Date.parse(vg[i]['date'].to_s)
      rescue ArgumentError 
        nil
      end
      @feed.push(vg[i])
    end
    books = Book.where(:agent => @agent).select("updated_at AS date, created_at, updated_at AS updated_at").limit(55).order('date DESC, finished DESC, started DESC, received dESC')
    books.each_index do |i|
      # begin
      #   books[i].date = Date.parse(books[i]['date'])
      # rescue
      #   nil
      # end
      next if i.nil?
      @feed.push(books[i])
    end
    @feed = @feed.compact.sort{|x, y|  y.updated_at  <=>  x.updated_at  }[0..54]

    
    if @logged_in == true
      render :template => 'shared/agent_rss'
    else
      render  :template => 'shared/agent_protected_rss'
    end
  end



  def show

    @agent = Agent.find(params[:id])
    @profile = Profile.find_by(:agent => @agent, :year => getYear)
    if @profile.nil?
      @profile = Profile.where(:agent => @agent).sort_by{|x| x.year }.last
      # theme @profile.theme.name
      redirect_to("http://#{@profile.year}.bloodteam.com/agents/#{params[:id]}")
    else  
      theme 'classic'

      @newsfeed = Entry.where(:agent => @agent).joins(:agent).group([:entry_type, :entry_id]).order('created_at DESC').page(params[:page]).per(10)
      @json = Entry.where(:agent => @agent).order('created_at DESC').limit(150).to_a.delete_if{|x| !x.entry.respond_to?('geolocation_id')}.delete_if{|x| x.entry.geolocation_id.nil? }.map{|x| x.entry.geolocation }

      if request.xhr?
        render :partial => 'shared/newsfeed', :collection => @newsfeed, :locals => {:no_agent_icon => false }
      else
        set_meta_tags :title => "Agent #{@profile.surname}"
        render :template => 'agent_profile'
      end

    end
  end
  
  def update
    @agent = Agent.friendly.find(params[:id])
    if @agent == current_agent
      if @agent.update_attributes(agent_params)
        flash[:notice] ='Your settings have been updated.'
        redirect_to '/settings'
      else
        flash[:error] = 'There was an error saving your changes.'
      end
    end
  end
      
  
  def your_settings
    @profiles = Profile.where(:agent_id => current_agent.id).sort{|x, y| y.year <=> x.year }
    set_meta_tags :title => 'Your PBT settings'
    render :template => 'shared/your_settings'
  end
  
  private
  
  def agent_params
    params.require(:agent).permit(:surname, :agent_since, :lastfm, :twitname, :age, :email, :location, :missionname, :password, :password_confirmation, :username, :public_password)
  end
  
end
