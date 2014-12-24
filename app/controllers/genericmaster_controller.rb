# -*- encoding : utf-8 -*-
class GenericmasterController < ApplicationController
  respond_to :html, :xml
  before_filter :getView
  before_filter :getCategory
  before_filter :authenticate_agent!, :only => [:new, :edit, :update, :create, :destroy, :directid,  :unreviewed]
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
    logger.warn('access_token token is ' + session[:discogs_token].inspect)
    @discogs.access_token = access_token
    logger.warn('@discogs.access_token is ' + @discogs.access_token.inspect)
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
      redirect_to url_for(@item)
    else
      flash[:error] = 'Error creating entry: '  + @item.errors.full_messages.join('; ')
      render :template => 'shared/new_master'
    end
    
  end

  def create_master
    if @category == 'Movie'
      if @new_master = MasterMovie.create(params[:master_movie])
        if params[:master_movie][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating movie record.'
      end
    elsif @category == 'Music'
      if @new_master = MasterMusic.create(params[:master_music])
        if params[:master_music][:followup] == 'new'
          redirect_to select_genericmaster_path(:agent_id => current_agent.id, :id => "local_" + @new_master.id.to_s, :category => @category)
        else
          redirect_to @new_master
        end
      else
        flash[:error] = 'Error creating music record.'
      end
    elsif @category == 'Book'
      if @new_master = MasterBook.create(params[:master_book])
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
    @followup = params[:followup]
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
    @item = @category.classify.constantize.new(:agent => current_agent, (@master.gsub(/^Master/, 'master_') + '_id').downcase.to_sym => @master.classify.constantize.choose(params[:id].gsub(/^tt/, '')), :add_to_newsfeed => true)
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
    if @category == 'Book' || @category == 'Videogame'
      date = ' finished DESC, started DESC, received '
    else
      date = ' date '
    end
   
    joins = [:agent,  :userimages]
    joins.push(:geolocation) if @category == 'Movie'
    if params[:agent_id]
      @agent = Agent.friendly.find(params[:agent_id])
      if @category == 'Book' || @category == 'Videogame' 
        if getYear == Time.now.strftime('%Y')
          @items = @category.classify.constantize.includes([:agent, :userimages, :comments,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished,received), coalesce(finished, received, started), coalesce(received, started, finished)) as date").where(:agent => @agent).order('date desc').page(params[:page]).per(50)
        else
          @items = @category.classify.constantize.includes([:agent, :userimages, :comments,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished,received), coalesce(finished, received, started), coalesce(received, started, finished)) as date").where(:agent => @agent).where("(received >= '#{getYear}-01-01' AND received <= '#{getYear}-12-31') OR (started >= '#{getYear}-01-01' AND started < '#{getYear}-12-31') OR (finished >= '#{getYear}-01-01' AND finished < '#{getYear}-12-31')").order('date desc').page(params[:page]).per(50)
        end
      elsif @category == 'Tvseries' 
        if getYear == Time.now.strftime('%Y')
          @items = @category.classify.constantize.includes([:agent, :userimages, :comments,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished), coalesce(finished,  started)) as date").where(:agent => @agent).order('date desc').page(params[:page]).per(50)
        else
          @items = @category.classify.constantize.includes([:agent, :userimages, :comments,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished), coalesce(finished, started)) as date").where(:agent => @agent).where("(received >= '#{getYear}-01-01' AND received <= '#{getYear}-12-31') OR (started >= '#{getYear}-01-01' AND started < '#{getYear}-12-31') OR (finished >= '#{getYear}-01-01' AND finished < '#{getYear}-12-31')").order('date desc').page(params[:page]).per(50)
        end
      else
        @items = @category.classify.constantize.includes([:agent , :comments,  
            "master_#{@category.downcase}".to_sym, :userimages]).where(:agent => @agent).where("date <= '#{getYear}-12-31'").order(date + ' DESC').page(params[:page]).per(50)
      end
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
              ]).select("*, greatest(coalesce(started,finished,received), coalesce(finished, received, started), coalesce(received, started, finished)) as date").order("date desc").paginate(:per_page => 20, :page => params[:page])
        else
          @items = @category.classify.constantize.includes([:agent, 
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => joins} }
              ]).select("*, greatest(coalesce(started,finished,received), coalesce(finished, received, started), coalesce(received, started, finished)) as date").where("(received >= '#{getYear}-01-01' AND received <= '#{getYear}-12-31') OR (started >= '#{getYear}-01-01' AND started < '#{getYear}-12-31') OR (finished >= '#{getYear}-01-01' AND finished < '#{getYear}-12-31')").order('date desc').paginate(:per_page =>  (theme_name == 'flume' ? 50 : 20 ), :page => params[:page])
              # where("(received >= '#{getYear}-01-01' AND received <= '#{getYear}-12-31') OR (started >= '#{getYear}-01-01' AND started < '#{getYear}-12-31') OR (finished >= '#{getYear}-01-01' AND finished < '#{getYear}-12-31')").includes(:userimages).sort{|x,y| y.date <=> x.date}.paginate(:per_page => 20, :page => params[:page])
        end
      else
        @items = @category.classify.constantize.includes([:agent,
            {"master_#{@category.downcase}".to_sym => {@category.downcase.tableize.to_sym => [:agent, :userimages]}
              }]).where("date <= '#{getYear}-12-31'").paginate(:per_page => 20, :page => params[:page], :order => date + ' DESC')
      end
      if request.xhr?
        render :partial => 'shared/item', :collection => @items, :locals => {:searchterm => nil}
      else
        render :template => 'shared/index_for_category'
      end
    end
  end  
  
  def query
    if params[:directid]
      redirect_to :action => :directid, id: params[:directid]
    else
      begin
        @localhits = @master.classify.gsub(/^Master/, '').constantize.search(ThinkingSphinx::Query.escape(params[:query])).map{|x| x.master}.uniq
      rescue ThinkingSphinx::ConnectionError
        @localhits = []
      end      
      begin
         if @master == "MasterMusic"\
           # OK so this fucker won't work as a model method right now.... grrr......
           @discogs = Discogs::Wrapper.new("PBT development", session[:discogs_token])
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
        die
      end
      if @choices && @localhits
        set_meta_tags :title => 'Searching for ' + params[:query]
        render :template => 'shared/choose'
      end
    end
  end

    
  def select
    @item = @category.classify.constantize.new(:agent => current_agent, (@master.gsub(/^Master/, 'master_') + '_id').downcase.to_sym => @master.classify.constantize.choose(params[:id], session[:discogs_token]), :add_to_newsfeed => true)

    @item.userimages << Userimage.new(:primary => true)
    if @item.respond_to?('currency_id')
      @item.currency_id = current_agent.default_currency
    end
    set_meta_tags :title => "New entry for " + @item.name
    render :template => 'shared/new_master'
  end
  

  def shorts
    if params[:agent_id]
      @agent = Agent.find(params[:agent_id])
      @items = @category.classify.constantize.includes(:userimages).where(:agent_id => params[:agent_id]).where(:is_short => true).order('date DESC').paginate(:per_page =>  (theme_name == 'flume' ? 40 : 20 ), :page => params[:page])
      if request.xhr?
        render :partial => '/agent', :collection => @items
      else
        render :template => 'index_for_agent'
      end
    else
      @items = @category.classify.constantize.where(:is_short => true).paginate(:per_page =>  (theme_name == 'flume' ? 40 : 20 ), :page => params[:page], :include => [:agent, :userimages, @master.gsub(/^Master/, 'master_').downcase.to_sym], :order => 'date DESC')
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
    else
 
      @singular = @category
      @master = 'master_' + @category.downcase
      item = @singular.classify.constantize.find(params[:id])
      @item = @master.classify.constantize.includes([:comments, 
        {"#{@singular.downcase.pluralize}".to_sym => [:agent, :userimages, "#{@master.tableize.singularize}".to_sym]}
        ]).find(item.master_id)

    end


    if item.class == Movie || item.class == MasterMovie
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
    @item = @category.classify.constantize.where("comment = '' OR comment is null").where(:agent_id => current_agent.id).first(:offset => offset)
    @item.add_to_newsfeed = true
    render :template => 'shared/new_master'
  end

  def unreviewedlp
    require 'discogs'
    offset = rand(@category.classify.constantize.includes(:master_music).where("master_musics.format LIKE '%LP%' OR master_musics.format LIKE '%inyl%'").where("comment = '' OR comment is null").where(:agent_id => current_agent.id).count)
    @item = @category.classify.constantize.includes(:master_music).where("master_musics.format LIKE '%LP%' OR master_musics.format LIKE '%inyl%'").where("comment = '' OR comment is null").where(:agent_id => current_agent.id).first(:offset => offset)
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
      if @item.update_attributes(params[@category.tableize.singularize])
 
        if @category == 'MasterMovie'
          if @item.filename_file_name.blank? && !@item.imdbcode.blank?
          i = IMDB.new(@item.imdbcode)
          big_poster = i.poster_link
          unless big_poster.blank?
              @item.filename_file_name = @item.imdbcode.to_s  + '.jpg'
              @item.filename_content_type = 'image/jpeg'
              system("mkdir -p " + Rails.root.to_s  + '/public/images/master_movies/' + @item.id.to_s + '/thumb')
              system("mkdir -p " + Rails.root.to_s  + '/public/images/master_movies/' + @item.id.to_s + '/full')
              open(Rails.root.to_s + '/public/images/master_movies/' + @item.id.to_s + '/thumb/' +   @item.imdbcode.to_s + '.jpg', "wb").write(open(i.poster_small).read) rescue nil
              open(Rails.root.to_s  + '/public/images/master_movies/' + @item.id.to_s + '/full/' +   @item.imdbcode.to_s + '.jpg', "wb").write(open(big_poster).read) rescue nil
              @item.save!
          end
        elsif @category == 'MasterMusic'
          if @item.filename_file_name.blank? && !@item.discogscode.blank?
            m = Discogs::Wrapper.new('f6d728eef1').get_release(@item.discogscode.to_s)
            unless m.nil?
              unless m.images.blank?

                @item.filename_file_name = CGI.escape(@item.discogscode.to_s + '.jpg')
                system("mkdir -p " + Rails.root.to_s + '/public/images/master_musics/' + @item.id.to_s + "/thumb")
                 system("mkdir -p " + Rails.root.to_s + '/public/images/master_musics/' + @item.id.to_s + "/full")
                open(Rails.root.to_s+'/public/images/master_musics/' + @item.id.to_s + '/thumb/' + @item.filename_file_name, "wb").write(open(m.images.first.uri150).read)
                open(Rails.root.to_s+'/public/images/master_musics/' + @item.id.to_s + '/full/' + @item.discogscode.to_s + '.jpg', "wb").write(open(m.images.first.uri150.gsub(/\-150\-/, '-')).read)
                @item.save!
              end
            end
          end
        end
      end
        expire_fragment(/genericmaster\/#{Regexp.escape(@item.master_id.to_s)}\?(.*)category\=master#{Regexp.escape(@item.class.to_s.downcase)}/)
        expire_fragment(/.*newsfeed_front.*/)       
        flash[:notice] = 'Entry updated.'
      else
        flash[:error] = 'ERror'
      end
    else
      if @item.agent == current_agent
        if @item.update_attributes(params[@category.downcase])
          expire_fragment(/genericmaster\/#{Regexp.escape(@item.master_id.to_s)}\?(.*)category\=master#{Regexp.escape(@item.class.to_s.downcase)}/)
          expire_fragment(/.*newsfeed_front.*/)
          flash[:notice] = 'Entry updated.'
        end
      end
    end
    redirect_to url_for(@item)
  end

  protected
  
  def permitted_params 
    params.permit(:master_music  => [:artist, :title, :label, :year, :format, :discogscode])
  end

end


