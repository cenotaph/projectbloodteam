# -*- encoding : utf-8 -*-
class GenericController < ApplicationController
  respond_to :html, :xml
  before_filter :getView, :getCategory
  before_filter :authenticate_agent!, :only => [:new, :edit, :update, :create, :create_references, :destroy]
  theme :getTheme 
  
  autocomplete :bar, :name

  def getCategory
    @category = params[:category]
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
    set_meta_tags :title => "Aggregate entries for " + @item.name
    render :template => 'shared/aggregate'
  end
  
  def create_references
    @item = params[:references][:source_type].classify.constantize.find(params[:references][:source_id])
    @item.references = []
    params[:pr].delete_if{|x| x["activated"] == "0" }.each do |reference|
      @item.references << Reference.new(reference_id: reference['reference_id'], reference_type: reference['reference_type'], comment: reference['comment'])
    end
    flash[:notice] = 'The entry has been saved.'
    @item.save!
    redirect_to url_for(@item)
  end
  
  def create
    @item = @category.classify.constantize.new(params[@category.downcase].permit!)
    if @item.save 
      flash[:notice] = 'Entry created'
    
      if @category == 'Comment'
        if @item.item.class.to_s =~ /^Master/
          expire_fragment(/genericmaster\/#{Regexp.escape(@item.item.id.to_s)}\?(.*)category\=#{Regexp.escape(@item.item.class.to_s.downcase)}/)
        end
        expire_fragment(/.*forum_front.*/)
        unless @item.entries.empty?
          expire_fragment(/.*newsfeed_front.*/)
        end  
        if request.xhr?
          render :partial => 'shared/ajax_comment', :locals => {:comment => @item}
        else
          redirect_to url_for(@item)
        end
      else
        unless @item.entries.empty?
          expire_fragment(/.*newsfeed_front.*/)
        end
        
        # new references code
        if @item.comment.blank?
          redirect_to url_for(@item)
        else
          @potential_references = @item.check_references
          
          if @potential_references.empty?
            redirect_to url_for(@item)
          else
            flash[:notice] = 'Did you mention these other items in your comment?'
            render :template => 'shared/add_references'
          end
        end
        
      end
    else
      flash[:error] = 'Error creating entry: ' + @item.errors.full_messages.join('; ')
      if request.xhr?
        render :text => flash[:error]
      else
        if @category == 'Comment'
          render :template => 'shared/show'
        else
          set_meta_tags :title => "New #{@category.downcase}"
          render :template => 'shared/new'
        end
      end
    end

  end
  
  def destroy
    @item = @category.classify.constantize.find(params[:id])
    if @item.agent == current_agent
      @item.destroy
      expire_fragment(/.*forum_front.*/)
      if @item.class == Comment
        if @item.item.class.to_s =~ /^Master/
          expire_fragment(/genericmaster\/#{Regexp.escape(@item.item.id.to_s)}\?(.*)category\=#{Regexp.escape(@item.item.class.to_s.downcase)}/)
        end
        unless @item.entries.empty?
          expire_fragment(/.*newsfeed_front.*/)
        end  
      else
        unless @item.entry.empty?
          expire_fragment(/.*newsfeed_front.*/)
        end      
      end
    end
    redirect_to "/agents/#{current_agent.id.to_s}/#{@category.classify.constantize.table_name}"
  end

  def edit

    @item = @category.classify.constantize.find(params[:id])
    if @item.agent == current_agent
      if @category == 'Comment'
        @comment = @item
        render :template => 'shared/_new_comment'
      else
        set_meta_tags :title => "Edit #{@category.downcase}: #{@item.name}"
        render :template => 'shared/new'
      end
    end
  end
  
  def index
    joins = [:agent, :comments, :userimages]
    joins.push(:geolocation) if @category.classify.constantize.new.respond_to?('geolocation')
    joins.push(:currency) if @category.classify.constantize.new.respond_to?('currency_id')
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
      %w{name destination comment company ordered location product task games station cuisine}.each do |field|

        if sample.respond_to?(field.to_sym)
        
          filter_query << "lower(#{field.to_s}) like '%#{@filter_text.downcase}%'"
        end
      end
      filter_query = filter_query.join(" OR ")

    end
    filter_query = 1 if filter_query.blank?

    if params[:agent_id]
      @agent = Agent.find(params[:agent_id])
      @items = @category.classify.constantize.where(:agent => @agent).where("date <= '#{@end_date}' AND date >= '#{@start_date}'").where(filter_query).includes(joins).order([@sort, @sort_direction].join(' ') + ", date #{@sort_direction}, id #{@sort_direction}").page(params[:page]).per(@per)

      if request.xhr?
        render :partial => '/agent', :collection => @items
      else
        set_meta_tags :title => "Agent #{@agent.surname}: " + @category.pluralize.humanize
        render :template => 'index_for_agent'
      end
      
      
      
    else
      if agent_signed_in?
        @items = @category.classify.constantize.where("date <= '#{getYear}-12-31'").includes([
          joins
          ]).order('date DESC').page(params[:page]).per(40)
      else
        @items = @category.classify.constantize.where("date <= '#{getYear}-12-31'").includes(joins).where("agents.security < 2").paginate(:per_page =>  (theme_name == 'flume' ? 40 : 20 ), :page => params[:page], :order => 'date DESC')
        flash[:notice] = 'You are not seeing all entries because you are not logged in.'
      end
      if request.xhr?
        render :partial => 'shared/item', :collection => @items, :locals => {:searchterm => nil}
      else
        set_meta_tags :title => @category.pluralize.humanize
        render :template => 'shared/index_for_category'
      end
    end
    
  end  
    
    
  def new
    @item = @category.classify.constantize.new(:agent => current_agent, :add_to_newsfeed => true)
    if @item.respond_to?('currency_id')
      @item.currency_id = current_agent.default_currency
    end
    @item.userimages << Userimage.new(:primary => true)
    set_meta_tags :title => "New #{@category.downcase}"
    render :template => 'shared/new'
  end
  
  
  def show
    @item = @category.classify.constantize.find(params[:id])
    unless !@item.respond_to?('geolocation')
      unless @item.geolocation_id.blank?
        hits = [@item]
        hits += Geolocation.where(["latitude >= ? and latitude <= ? and longitude >= ? and longitude <= ?", @item.geolocation.latitude - 1.5, @item.geolocation.latitude + 1.5, @item.geolocation.longitude - 1.5, @item.geolocation.longitude + 1.5]).map{|x| x.send(@category.pluralize.downcase)}.uniq.flatten

      end
      @json = hits.map(&:geolocation).uniq unless hits.nil?
    end
    
    if @item.class == Comment
      redirect_to @item.child
    else
      if request.xhr?
        @prev = params[:prev_id] unless params[:prev_id].blank?
        @next = params[:next_id] unless params[:next_id].blank?
        render :template => 'shared/ajaxshow', :layout => false
      else
        set_meta_tags :title => @category.humanize + ": " + @item.name.to_s
        render :template => 'shared/show'
      end      
    end
  end
 
  def update
    @item = @category.classify.constantize.find(params[:id])
    if @item.agent == current_agent
      if @item.update_attributes(params[@category.downcase].permit!)
        unless @item.entries.empty?
          expire_fragment(/.*newsfeed_front.*/)
        end        
        flash[:notice] = 'Entry updated.'
      end
      if @item.comment.blank?
        redirect_to url_for(@item)
      else
        @potential_references = @item.check_references
        
        if @potential_references.empty? || @potential_references == @item.references
          redirect_to url_for(@item)
        else
          flash[:notice] = 'Did you mention these other items in your comment?'
          render :template => 'shared/add_references'
        end
      end
    end
  end
end
