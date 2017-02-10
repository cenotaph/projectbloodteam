# -*- encoding : utf-8 -*-
class GenericmasterController < ApplicationController
  respond_to :html, :xml
  before_action :getView
  before_action :getCategory
  before_action :authenticate_agent!, :only => [:new, :edit, :edit_master, :update, :create, :destroy, :directid, :authenticate, :callback, :unreviewed]
  theme :getTheme
  autocomplete :movie, :location
  
  def getCategory
    @category = params[:category]
    case @category
      when 'Movie'
        @master = 'MasterMovie'
      when 'MasterMovie'
        @master = 'MasterMovie'
      when 'Music' 
        @master = 'MasterMusic'
      when 'Tvseries'
        @master = 'MasterTvseries'
      when 'MasterTvseries'
        @master = 'MasterTvseries'
      when 'MasterMusic'
        @master = 'MasterMusic'
      when 'Book'
        @master = 'MasterBook'
      when 'MasterBook'
        @master = 'MasterBook'
      when 'Videogame'
        @master = 'MasterVideogame'
      when 'MasterVideogame'
        @master = 'MasterVideogame'
      
    end
  end
  
  def find_agent
     if params[:agent_id]
       @agent = Agent.find(params[:agent_id]) 
     end

   end
   
   
  def aggregate
    @item = @category.classify.constantize.where(:id => params[:id]).first
    discussion = @item.discussion
    @item.similars.each do |s|
      discussion << s.discussion
    end
    @discussion = discussion.flatten.sort{|x,y| y.created_at <=> x.created_at }
    set_meta_tags :title => 'Aggregate'
    render :template => "_discussion", :locals => {:discussion => @discussion }
  end
   
  def aggregate_creators
    @item = @category.classify.constantize.where(:id => params[:id]).first
    # ugly, fix later
    if @item.class == MasterBook
      @all_titles = MasterBook.where(:author => @item.author)
      set_meta_tags :title => 'All entries for ' + @item.author
    elsif @item.class == MasterMovie
      @all_titles = MasterMovie.where(:director => @item.director).order(:year)
      set_meta_tags :title => 'All entries for ' + @item.director
    elsif @item.class == MasterMusic
      @all_titles = MasterMusic.where("artist like ?", "%#{@item.artist}%").includes([{:musics => [:agent, :userimages, :master_music]} , :comments]).order(:year)
      set_meta_tags :title => 'All entries for ' + @item.artist
    end
    
    render :template => 'shared/aggregate_creator'
  end
  
  def authenticate
    session[:my_previous_url] = URI(request.referer).path
    session[:discogs_token] = nil
    @discogs = Discogs::Wrapper.new("PBT development")
    app_key      = ENV["DISCOGS_KEY"]
    app_secret   = ENV["DISCOGS_SECRET"]
    request_data = @discogs.get_request_token(app_key, app_secret, ENV['DISCOGS_CALLBACK'])

    session[:request_token] = request_data[:request_token]
    logger.warn('request token is ' + session[:request_token].inspect)
    redirect_to request_data[:authorize_url]
  end
  
  
  def callback
    @discogs = Discogs::Wrapper.new("PBT development")
    request_token = session[:request_token]
    verifier      = params[:oauth_verifier]
    access_token  = @discogs.authenticate(request_token, verifier)

    session[:request_token] = nil
    session[:discogs_token]  = access_token
    # logger.warn('access_token token is ' + session[:discogs_token].inspect)
    @discogs.access_token = access_token
    encrypt_access_token = Marshal.dump(access_token)
    current_agent.update_attribute(:discogs_token, encrypt_access_token)
    
    # logger.warn('@discogs.access_token is ' + @discogs.access_token.inspect)
    if session[:my_previous_url].nil?
      redirect_to '/'
    else
      redirect_to session[:my_previous_url]
    end
  end
  
  def create
    @item = @category.classify.constantize.new(params[@category.downcase].permit!)
    if @item.save 
      flash[:notice] = 'Entry created'
      expire_fragment(/genericmaster\/#{Regexp.escape(@item.master.id.to_s)}\?(.*)category\=#{Regexp.escape(@item.master.class.to_s.downcase)}/)
      expire_fragment(/.*newsfeed_front.*/)
      
      # new references code
      if @item.comment.blank?
        redirect_to url_for(@item)
      else
        @potential_references = @item.check_references.delete_if{|x| x == @item.master}
      
        if @potential_references.empty?
          redirect_to url_for(@item)
        else
          flash[:notice] = 'Did you mention these other items in your comment?'
          render :template => 'shared/add_references'
        end
      end
      flash[:notice] = 'Entry updated.'

    
    else
      flash[:error] = 'Error creating entry: '  + @item.errors.full_messages.join('; ')
      render :template => 'shared/new_master'
    end
    
  end

  def create_master
    if @category == 'Movie'
      if @new_master = MasterMovie.create(params[:master_movie].permit!)
        if params[:master_movie][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating movie record.'
      end
    
    elsif @category == 'Tvseries'
      if @new_master = MasterTvseries.create(params[:master_tvseries].permit!)
        if params[:master_tvseries][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating TV record.'
      end
      
    elsif @category == 'Music'
      if @new_master = MasterMusic.create(params[:master_music].permit!)
        if params[:master_music][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating music record.'
      end
    elsif @category == 'Book'
      if @new_master = MasterBook.create(params[:master_book].permit!)
        if params[:master_book][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating book record.'
      end
    elsif @category == 'Videogame'
      if @new_master = MasterVideogame.create(params[:master_videogame])
        if params[:master_videogame][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating videogame record.'
      end
    end
  end
  
  def custom_master
    @followup = 'new'
    set_meta_tags :title => "Custom entry"
    render :template => 'shared/custom'
  end
  
  def destroy
    @item = @category.classify.constantize.find(params[:id])
    if @item.agent == current_agent
      @item.destroy
      redirect_to "/agents/#{current_agent.id.to_s}/#{@category.classify.constantize.table_name}"
    end
  end
  
  def directid
    @item = @category.classify.constantize.new(:agent => current_agent, (@master.gsub(/^Master/, 'master_') + '_id').downcase.to_sym => @master.classify.constantize.choose(params[:directid].gsub(/^tt/, ''), session[:discogs_token].nil? ? (current_agent.discogs_token.blank? ? nil : current_agent.discogs_token) : session[:discogs_token]), :add_to_newsfeed => true)
    @item.userimages << Userimage.new(:primary => true)
    if @item.respond_to?('currency_id')
      @item.currency_id = current_agent.default_currency
    end
    set_meta_tags :title => 'New entry for ' + @item.name
    render :template => 'shared/new_master'
  end
  
  def edit
    @item = @category.classify.constantize.find(params[:id])
    if @item.agent == current_agent
      set_meta_tags :title => 'Editing entry: ' + @item.name
      render :template => 'shared/new_master'
    end
  end
  
  def edit_master
    @item = @category.classify.constantize.find(params[:id])
    set_meta_tags :title => 'Editing master record: ' + @item.name
    render :template => 'shared/edit_master'
  end
  
  def index
    if @category == 'Book' || @category == 'Videogame' || @category == 'Tvseries'
      date = ' finished DESC, started DESC, received '
    else
      date = ' date '
    end

    if params[:filter].nil?
      params[:filter] = ActionController::Parameters.new
    else
      @filters = true
    end
    @per =  params[:filter][:per].blank? ? 40 : params[:filter][:per]
    @start_date = params[:filter][:start_date].blank? ? '2002-01-01' : params[:filter][:start_date] 
    @end_date = params[:filter][:end_date].blank? ?  getYear + '-12-31' : params[:filter][:end_date]
    @sort_direction = params[:filter][:sort_direction].blank? ? 'DESC' : params[:filter][:sort_direction]
    @sort = params[:filter][:sort].blank? ? "date " : params[:filter][:sort] 
    @filter_text = params[:filter][:filter_text]
    

    unless @filter_text.blank?
      filter_query = []

      sample =  @category.classify.constantize.first
      %w{name title destination comment company ordered location product task games station cuisine}.each do |field|

        if !sample[field.to_sym].nil?          
          filter_query << "lower(#{@category.downcase.tableize}.#{field.to_s}) like '%#{@filter_text.downcase}%'"
        end
        if !sample.master[field.to_sym].nil?
          filter_query << "lower(master_#{@category.downcase.tableize}.#{field.to_s}) like '%#{@filter_text.downcase}%'"
        end
      end
      filter_query = filter_query.join(" OR ")
   
    end
    filter_query = '' if filter_query.blank?
       
 
   
    joins = [:agent,  :userimages, :comments]
    joins.push(:geolocation) if @category == 'Movie'

    if params[:agent_id]
      @agent = Agent.friendly.find(params[:agent_id])
      
      if @category == 'Book' || @category == 'Videogame' 

          @items = @category.classify.constantize.select("*, greatest(coalesce(#{@category.downcase.tableize}.started,#{@category.downcase.tableize}.finished,#{@category.downcase.tableize}.received), coalesce(#{@category.downcase.tableize}.finished, #{@category.downcase.tableize}.received, #{@category.downcase.tableize}.started), coalesce(#{@category.downcase.tableize}.received, #{@category.downcase.tableize}.started, #{@category.downcase.tableize}.finished)) as date").includes([:agent, :userimages, :comments]).includes("master_#{@category.downcase}".to_sym =>  @category.downcase.tableize).where(filter_query).where(:agent => @agent).where("(#{@category.downcase.tableize}.received >= '#{@start_date}' AND #{@category.downcase.tableize}.received <= '#{@end_date}') OR (#{@category.downcase.tableize}.started >= '#{@start_date}' AND #{@category.downcase.tableize}.started < '#{@end_date}') OR (#{@category.downcase.tableize}.finished >= '#{@start_date}' AND #{@category.downcase.tableize}.finished < '#{@end_date}')").order(["#{@sort}", @sort_direction].join(' ') + ", #{@category.downcase.tableize}.finished #{@sort_direction}, #{@category.downcase.tableize}.started #{@sort_direction}, #{@category.downcase.tableize}.received #{@sort_direction}, #{@category.downcase.tableize}.id #{@sort_direction}").page(params[:page]).per(@per)
        
      elsif @category == 'Tvseries' 

          @items = @category.classify.constantize.includes([:agent, :userimages, :comments,     "master_#{@category.downcase}".to_sym]).select("*, greatest(coalesce(started,finished), coalesce(finished, started)) as date").where(:agent => @agent).where(filter_query).where("(started >= '#{@start_date}' AND started < '#{@end_date}') OR (finished >= '#{@start_date}' AND finished < '#{@end_date}')").order([@sort, @sort_direction].join(' ') + ", finished #{@sort_direction}, id #{@sort_direction}").page(params[:page]).per(@per)

        
        
      else
        @items = @category.classify.constantize.includes([:agent, :currency, :comments,
            "master_#{@category.downcase}".to_sym]).where(:agent => @agent).where(filter_query).where("date <= '#{@end_date}' AND date >= '#{@start_date}'").order([@sort, @sort_direction].join(' ') + ", date #{@sort_direction}, id #{@sort_direction}").page(params[:page]).per(@per)
       
      end
      @stats = {      
           "alltimecount" => @category.constantize.where(agent: @agent).count, 
           "year" => @start_date.match(/^\d\d\d\d/)[0] == @end_date.match(/^\d\d\d\d/)[0] ? @end_date.match(/^\d\d\d\d/)[0] : nil
         } 
      
      
      
      if request.xhr?
        render :partial => '/agent', :collection => @items
      else
        set_meta_tags :title => @category.pluralize + " for " + @agent.surname
        render :template => 'index_for_agent'
      end
    else
      if @category == 'Book' || @category == 'Videogame'
        if getYear == Time.now.strftime('%Y')
          @items = @category.classify.constantize.includes([:agent,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished,received), coalesce(finished, received, started), coalesce(received, started, finished)) as date").order("date desc").page(params[:page]).per(@per)
        else
          @items = @category.classify.constantize.includes([:agent, 
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished,received), coalesce(finished, received, started), coalesce(received, started, finished)) as date").where("(received >= '#{getYear}-01-01' AND received <= '#{getYear}-12-31') OR (started >= '#{getYear}-01-01' AND started < '#{getYear}-12-31') OR (finished >= '#{getYear}-01-01' AND finished < '#{getYear}-12-31')").order('date desc').page(params[:page]).per(@per)
              # where("(received >= '#{getYear}-01-01' AND received <= '#{getYear}-12-31') OR (started >= '#{getYear}-01-01' AND started < '#{getYear}-12-31') OR (finished >= '#{getYear}-01-01' AND finished < '#{getYear}-12-31')").includes(:userimages).sort{|x,y| y.date <=> x.date}.paginate(:per_page => 20, :page => params[:page])
        end
      else
        @items = @category.classify.constantize.includes([:agent,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => [:agent, :userimages]}
              }]).where("date <= '#{getYear}-12-31'").page(params[:page]).per(50).order('date DESC')
      end
      if request.xhr?
        render :partial => 'shared/item', :collection => @items, :locals => {:searchterm => nil}
      else
        set_meta_tags title: @category.pluralize
        render :template => 'shared/index_for_category'
      end
    end
  end  
  
  def query
    if params[:directid]
      redirect_to :action => :directid, id: params[:directid]
    else
      begin
        @localhits = @master.classify.gsub(/^Master/, '').constantize.search(ThinkingSphinx::Query.escape(params[:query]), :per_page => 999).map{|x| x.master}.uniq
      rescue ThinkingSphinx::ConnectionError
        if @master.classify.gsub(/^Master/, '').constantize == Movie
          @localhits = MasterMovie.where("title LIKE '%" + params[:query] + "%'")
        else
          @localhits = []
        end
      end      
      begin
        if @master == "MasterMusic"\
          # OK so this fucker won't work as a model method right now.... grrr......
          if session[:discogs_token]
            @discogs = Discogs::Wrapper.new("PBT development", session[:discogs_token])
          elsif !current_agent.discogs_token.blank?
            @discogs = Discogs::Wrapper.new("PBT development", Marshal.load(current_agent.discogs_token))
          end
          search =  @discogs.search(params[:query], :type => :release)
          #  = @discogs.search(params[:query].gsub(/\s/, '%20'), :type => :release)
          @choices = []
          search.results.each do |hit|
            next unless hit.uri =~ /\d+$/
            @choices << {"title" => hit.title, "label" => hit.label, "format" => hit.format, "summary" => hit.summary, "key" => hit.uri.match(/\d+$/)[0] }
          end
          
          
        else
          @choices = @master.classify.constantize.query(params[:query], session[:discogs_token]) #.delete_if{|x|         @localhits.map{|y| y.external_index}.include?(x['key'].to_i) }.each 
         end
      rescue Discogs::AuthenticationError
        @choices = []
      end
      if @choices && @localhits
        set_meta_tags :title => 'Searching for ' + params[:query]
        render :template => 'shared/choose'
      end
    end
  end

    
  def select
    @item = @category.classify.constantize.new(:agent => current_agent, (@master.gsub(/^Master/, 'master_') + '_id').downcase.to_sym => @master.classify.constantize.choose(params[:id], session[:discogs_token].nil? ? (current_agent.discogs_token.blank? ? nil : current_agent.discogs_token) : session[:discogs_token]), :add_to_newsfeed => true)

    @item.userimages << Userimage.new(:primary => true)
    if @item.respond_to?('currency_id')
      @item.currency_id = current_agent.default_currency
    end
    set_meta_tags :title => "New entry for " + @item.name
    render :template => 'shared/new_master'
  end
  

  def shorts
    if params[:filter].nil?
      params[:filter] = ActionController::Parameters.new
    else
      @filters = true
    end
    @per =  params[:filter][:per].blank? ? 40 : params[:filter][:per]
    @start_date = params[:filter][:start_date].blank? ? '2002-01-01' : params[:filter][:start_date] 
    @end_date = params[:filter][:end_date].blank? ?  getYear + '-12-31' : params[:filter][:end_date]
    @sort_direction = params[:filter][:sort_direction].blank? ? 'DESC' : params[:filter][:sort_direction]
    @sort = params[:filter][:sort].blank? ? "date " : params[:filter][:sort] 
    @filter_text = params[:filter][:filter_text]
    
    set_meta_tags title: 'Shorts'
    
    unless @filter_text.blank?
      filter_query = []

      sample =  @category.classify.constantize.first
      %w{name title destination comment company ordered location product task games station cuisine}.each do |field|

        if !sample[field.to_sym].nil?          
          filter_query << "lower(#{@category.downcase.tableize}.#{field.to_s}) like '%#{@filter_text.downcase}%'"
        end
        if !sample.master[field.to_sym].nil?
          filter_query << "lower(master_#{@category.downcase.tableize}.#{field.to_s}) like '%#{@filter_text.downcase}%'"
        end
      end
      filter_query = filter_query.join(" OR ")
   
    end
    filter_query = 1 if filter_query.blank?
    
    if params[:agent_id]
      @agent = Agent.find(params[:agent_id])
      @items = @category.classify.constantize.includes(:userimages).where(:agent => @agent).where(:is_short => true).where(filter_query).where("date <= '#{@end_date}' AND date >= '#{@start_date}'").order([@sort, @sort_direction].join(' ') + ", date #{@sort_direction}, id #{@sort_direction}").page(params[:page]).per(@per)

      
      if request.xhr?
        render :partial => '/agent', :collection => @items
      else
        render :template => 'index_for_agent'
      end
    else
      @items = @category.classify.constantize.where(:is_short => true).page(params[:page]).per(@per).order([@sort, @sort_direction].join(' ') + ", date #{@sort_direction}, id #{@sort_direction}")
      if request.xhr?
        render :partial => '/item', :collection => @items
      else
        render :template => 'shared/index_for_category'
      end
    end
    
  end
  
  def show

    require 'discogs' if @category =~ /Music/
    if @category =~ /^Master/
      @singular = @category.gsub(/^Master/, '').downcase
      @master = @category

      @item = @master.classify.constantize.includes([:comments, 
        {"#{@singular.downcase.pluralize}".to_sym => [:agent, :userimages, "#{@master.tableize.singularize}".to_sym]}
        ]).find(params[:id])      
      item = @item
      if @item.items.map(&:agent_id).uniq.compact.size == 1
        @agent = Agent.find(@item.items.map(&:agent_id).uniq.compact.first)
        if @category =~ /Movie$/
          @stats = {"yearcount" => @singular.classify.constantize.where(agent: @agent).where("date >= '#{@item.items.first.date.year}-01-01' and date <= '#{@item.items.first.date.year}-12-31'").count,
           "alltimecount" => @singular.classify.constantize.where(agent: @agent).count,  "year" => @item.items.first.date.year,
           "position" => @singular.classify.constantize.where(agent: @agent).where("date >= '#{@item.items.first.date.year}-01-01' and date <= '#{@item.items.first.date.year}-12-31'").index(@item.items.first) + 1,
           "alltimeposition" => @singular.classify.constantize.where(agent: @agent).index(@item.items.first) + 1
           } 
        elsif @category =~ /Book$/ 
          unless @item.items.first.started.nil?  || @item.items.first.finished.nil?
           @stats = {"yearcount" => @singular.classify.constantize.where(agent: @agent).where("started >= '#{@item.items.first.started.year}-01-01' and finished <= '#{@item.items.first.finished.year}-12-31'").count,
            "alltimecount" => @singular.classify.constantize.where(agent: @agent).count,  "year" => @item.items.first.started.year,
            "position" => @singular.classify.constantize.where(agent: @agent).where("started >= '#{@item.items.first.started.year}-01-01' and finished <= '#{@item.items.first.finished.year}-12-31'").index(@item.items.first) + 1,
            "alltimeposition" => @singular.classify.constantize.where(agent: @agent).index(@item.items.first) + 1
            } 
          end
        elsif @category =~ /Music$/
          @stats = {"yearcount" => @singular.classify.constantize.where(agent: @agent).where("date >= '#{@item.items.first.date.year}-01-01' and date <= '#{@item.items.first.date.year}-12-31'").count,
            "alltimecount" => @singular.classify.constantize.where(agent: @agent).count,  "year" => @item.items.first.date.year,
            "position" => @singular.classify.constantize.where(agent: @agent).where("date >= '#{@item.items.first.date.year}-01-01' and date <= '#{@item.items.first.date.year}-12-31'").index(@item.items.first) + 1,
            "alltimeposition" => @singular.classify.constantize.where(agent: @agent).index(@item.items.first) + 1
            } 
        end
      end
    else
 
      @singular = @category
      @master = 'master_' + @category.downcase
      item = @singular.classify.constantize.find(params[:id])
      @item = @master.classify.constantize.includes([:comments,  :references,
        {"#{@singular.downcase.pluralize}".to_sym => [:agent, :userimages, "#{@master.tableize.singularize}".to_sym]}
        ]).find(item.master_id)
        
      if @item.others.map(&:agent_id).delete_if{|x| x == item.agent_id }.compact.empty?
        @agent = item.agent
        if !item[:date].nil?
          @stats = {"yearcount" => item.class.where(agent: @agent).where("date >= '#{item.date.year}-01-01' and date <= '#{item.date.year}-12-31'").count,
           "alltimecount" => item.class.where(agent: @agent).count, "position" =>  item.class.where(agent: @agent).where("date >= '#{item.date.year}-01-01' and date <= '#{item.date.year}-12-31'").index(item) + 1,
           "alltimeposition" => item.class.where(agent: @agent).index(item) + 1,
           "year" => item.date.year} 
        elsif !item[:started].nil?
          @stats = {"yearcount" => item.class.where(agent: @agent).where("finished is not null").where("(started >= '#{item.date.year}-01-01' and finished <= '#{item.date.year}-12-31') OR (finished >= '#{item.date.year}')").count,
           "alltimecount" => item.class.where(agent: @agent).count, 
           "position" =>  item.class.where(agent: @agent).where("started >= '#{item.date.year}-01-01' OR finished >= '#{item.date.year}'").index(item) + 1,
           "alltimeposition" => item.class.where(agent: @agent).index(item) + 1,
           "year" => item.date.year} 
         end
          
      end
    end


    if item.class == Movie || item.class == MasterMovie || item.class == Tvseries || item.class == MasterTvseries
      json = @item.discussion.delete_if{|x| x.class == Comment}.compact.delete_if{|x| x.geolocation_id.nil?}.map{|x| x.geolocation }.compact.delete_if{|x| x.latitude.nil? }
      # if !json.blank?
      #   json += Geolocation.where(["latitude >= ? and latitude <= ? and longitude >= ? and longitude <= ?", json.first.latitude - 1, json.first.latitude + 1, json.first.longitude - 1, json.first.longitude + 1])
      # end
      @json = @item.discussion.delete_if{|x| !x.respond_to?('geolocation')}.delete_if{|x| x.geolocation.nil?}.map(&:geolocation).uniq.compact
      
    end

    set_meta_tags :title => @item.name
    if request.xhr?
      @item = @category.classify.constantize.find(params[:id])
      render :template => 'shared/ajaxshow_master', :layout => false
    else
      # this a total mess; clean up later
      
      if @master == 'master_music' || @master == 'MasterMusic'
        if !@item.other_versions.empty?
          @agent = nil
          render :template => 'shared/different_records'
        else
          render :template => 'shared/master'
        end
      else
        render :template => 'shared/master'
      end
    end
  end
  
  def unreviewed
    require 'discogs'
    offset = rand(@category.classify.constantize.where("comment = '' OR comment is null").where(:agent_id => current_agent.id).count)
    @item = @category.classify.constantize.where("comment = '' OR comment is null").where(:agent_id => current_agent.id).offset(offset).first
    @item.add_to_newsfeed = true
    render :template => 'shared/new_master'
  end

  def unreviewedlp
    require 'discogs'
    offset = rand(@category.classify.constantize.joins(:master_music).where("master_musics.format LIKE '%LP%' OR master_musics.format LIKE '%inyl%'").where("comment = '' OR comment is null").where(:agent_id => current_agent.id).count)
    @item = @category.classify.constantize.joins(:master_music).where("master_musics.format LIKE '%LP%' OR master_musics.format LIKE '%inyl%'").where("comment = '' OR comment is null").where(:agent_id => current_agent.id).offset(offset).first
    @item.add_to_newsfeed = true
    render :template => 'shared/new_master'
  end 

  def needs_new_review
    require 'discogs'
    offset = rand(@category.classify.constantize.where("comment NOT REGEXP '[0-9]{4}\]$'").where(:agent_id => current_agent.id).count)
    @item = @category.classify.constantize.where("comment NOT REGEXP '[0-9]{4}\]$'").where(:agent_id => current_agent.id).first(:offset => offset)
    @item.add_to_newsfeed = true
    render :template => 'shared/new_master'
  end 
   
  def update
    @item = @category.classify.constantize.find(params[:id])
    if @category =~ /^Master/
 
      if @item.update_attributes(params[@category.tableize.singularize].permit!)

        if @category == 'MasterMovie'
          if (@item.filename_file_name.blank? && !@item.imdbcode.blank?) || params[:master_movie][:resync_image] == "1"
            i = Imdb::Movie.new(@item.imdbcode)
            big_poster = i.poster
            unless big_poster.blank?
              @item.filename = URI.parse(big_poster)
            end
            if @item.english_title.blank?
              unless i.also_known_as.find{|x| x[:version] == 'World-wide (English title)' }.nil?
                @item.english_title = HTMLEntities.new.decode  i.also_known_as.find{|x| x[:version] == 'World-wide (English title)' }[:title]
              end
            end
            @item.save!
          end
        elsif @category == 'MasterBook'
          unless @item.amazoncode.blank?
        
            if params[:master_book][:resync_image] == "1"

              @item.syncimage
            end
          end
        elsif @category == 'MasterMusic' 
          unless @item.discogscode.blank?
            if params[:master_music][:resync_image] == "1"
              @item.resync_discogs_image(session[:discogs_token])
            end
          end
        elsif @category == 'MasterTvseries'
          if (@item.image_file_name.blank? && !@item.imdbcode.blank?) || params[:master_tvseries][:resync_image] == "1"
            i = Imdb::Movie.new(@item.imdbcode)
            big_poster = i.poster
            unless big_poster.blank?
              @item.image = URI.parse(big_poster)
            end
            @item.save!
          end
        end        
  
        expire_fragment(/genericmaster\/#{Regexp.escape(@item.master_id.to_s)}\?(.*)category\=master#{Regexp.escape(@item.class.to_s.downcase)}/)
        expire_fragment(/.*newsfeed_front.*/)       
        flash[:notice] = 'Entry updated.'
      else
        flash[:error] = 'ERror'
      end
      redirect_to url_for(@item)
    else
      if @item.agent == current_agent
        if @item.update_attributes(params[@category.downcase].permit!)
          expire_fragment(/genericmaster\/#{Regexp.escape(@item.master_id.to_s)}\?(.*)category\=master#{Regexp.escape(@item.class.to_s.downcase)}/)
          expire_fragment(/.*newsfeed_front.*/)
          # new references code
          if @item.comment.blank?
            redirect_to url_for(@item)
          else
            @potential_references = @item.check_references.delete_if{|x| x == @item.master}
       
            if @potential_references.empty?
              redirect_to url_for(@item)
            else
              flash[:notice] = 'Did you mention these other items in your comment?'
              render :template => 'shared/add_references'
            end
          end
          flash[:notice] = 'Entry updated.'
        end
        
      end
    end
    
  end

  protected
  
  def permitted_params 
    params.permit(:master_music  => [:artist, :title, :label, :year, :format, :discogscode], :master_book => [:title, :author, :amazoncode, :filename], :master_movie => [:title, :director, :year, :country, :imdbcode, :filename, :english_title])
  end

end


