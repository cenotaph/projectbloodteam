# -*- encoding : utf-8 -*-
class AgentsController < InheritedResources::Base
  respond_to :html, :rss
  before_filter :login_required, :only => [:your_settings, :edit, :update]
  
  
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
    create! { 
       '/missing_profile'
    }
  end
  
  def edit
    @agent = Agent.find(params[:id])
    if current_agent == @agent
      @agent.twitpasswd = @agent.twitpasswd.tr("A-Ma-mN-Zn-z","N-Zn-zA-Ma-m") if @agent.twitpasswd
    else
     flash[:notice] = 'You cannot edit another agent\'s profile.'
     redirect_to '/settings/'
    end
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
    @agent = Agent.find(params[:id])
    respond_with(@agent)
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
      @feed += cat.find_all_by_agent_id(params[:id], :limit => 55, :order => 'date DESC')
    end
    vg = Videogame.find_all_by_agent_id(params[:id], :select => "*, updated_at AS date", :limit => 55, :order => 'finished DESC, started DESC, received DESC')
    vg.each_index do |i|
      begin
        vg[i].date = Date.parse(vg[i]['date'].to_s)
      rescue ArgumentError 
        nil
      end
      @feed.push(vg[i])
    end
    books = Book.find_all_by_agent_id(params[:id], :select => "*, updated_at AS date", :limit => 55, :order => 'date DESC, finished DESC, started DESC, received dESC')
    books.each_index do |i|
      # begin
      #   books[i].date = Date.parse(books[i]['date'])
      # rescue
      #   nil
      # end
      @feed.push(books[i])
    end
    
    @feed = @feed.compact.sort{|x, y|  y.updated_at  <=>  x.updated_at  }[0..54]
    if @logged_in == true
      render :rss => @feed, :template => 'shared/agent_rss'
    else
      render :rss => @feed, :template => 'shared/agent_protected_rss'
    end
  end



  def show
    @profile = Profile.where(:agent_id => params[:id]).where(:year => getYear).first
    if @profile.nil?
      @profile = Profile.where(:agent_id => params[:id]).sort_by{|x| x.year }.last
      # theme @profile.theme.name
      redirect_to("http://#{@profile.year}.bloodteam.com/agents/#{params[:id]}")
    else  
      theme @profile.theme.name
      @agent = Agent.find(params[:id])

      @newsfeed = Entry.paginate(:per_page => 10, :include => :agent, :group => [:entry_type, :entry_id], :conditions => ['agent_id = ?', params[:id]], :page => params[:page], :order => 'created_at DESC')   
      @json = Entry.where(:agent_id => params[:id]).order('created_at DESC').limit(150).delete_if{|x| !x.entry.respond_to?('geolocation_id')}.delete_if{|x| x.entry.geolocation_id.nil? }.map{|x| x.entry.geolocation }.to_gmaps4rails
      if request.xhr?
        render :partial => 'shared/newsfeed', :collection => @newsfeed, :locals => {:no_agent_icon => false }
      else
      render :template => 'agent_profile'
      end

      # respond_with(@agent)
    end
  end
  
  def your_settings
    @profiles = Profile.where(:agent_id => current_agent.id).sort{|x, y| y.year <=> x.year }
    render :template => 'shared/your_settings'
  end
end
