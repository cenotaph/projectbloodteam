# -*- encoding : utf-8 -*-
class ForumsController < ApplicationController
   before_filter :authenticate_agent!, :only => [:new, :edit, :add, :choose, :create, :update]
  
  def create
    @forum = Forum.new(forum_params)
    @forum.agent = current_agent
    if @forum.save 
      flash[:notice] = 'Entry created'
      expire_fragment(/.*forum_front.*/)
      unless @forum.entries.empty?
        expire_fragment(/.*newsfeed_front.*/)
      end
      redirect_to url_for(@forum)
    else
      flash[:error] = 'Error creating entry: '  + @forum.errors.full_messages.join('; ')
      render :template => 'shared/new_forum'
    end
  end

  def destroy
    expire_fragment(/.*newsfeed_front.*/)
    expire_fragment(/.*forum_front.*/)
    destroy! { '/forums' }
  end

  
  def edit
    @forum = Forum.find(params[:id])
    if @forum.agent != current_agent
      flash[:error] = 'This isn\'t your forum post to edit.'
      redirect_to @forum
    else
      render :template => 'shared/new_forum'
    end
  end
  
  
  def index
    # forums = Forum.find(:all, :order => 'created_at DESC')
    #  comments = Comment.find(:all, :conditions => 'category <> \'Forum\'',  :order => 'created_at DESC').group_by{|x| [x.category, x.foreign_id] }
    #  c = comments.collect{|x| x.last.first}
    #  @forum = forums.map{|f| f.discussion.sort{|x,y| y.created_at <=> x.created_at}.first} + c
    #  @forum.sort!{|x, y| y.created_at <=> x.created_at }
    #  @forum = @forum.paginate :per_page => 25, :page => params[:forum_page], :order => 'created_at DESC'
    # 
    # 
    # 
    # respond_to do |format|
    #   format.html{  render :layout => getTheme(current_agent ? current_agent.id : params[:id], getYear), :template => 'common/forum/forum' }
    #   format.js { 
    #      render :update do |page|
    #         page.replace 'theforum', :partial => "common/forum/forum" 
    #       end
    #     }
    #  end
    @forums = Comment.paginate_with_items(params[:page], 50)

    if request.xhr?
      render :partial => 'shared/forum_list', :collection => @forums
    else
      session.delete(:forum_unread)
      set_meta_tags :title => 'PBT forum'
      render :template => 'shared/forum'
    end
  end
  
    
  def new
   @forum = Forum.new(:agent => current_agent, :add_to_newsfeed => true)
   set_meta_tags :title => 'New forum post'
   render :template => 'shared/new_forum'
  end
  
  def show
    @item = Forum.find(params[:id])
    set_meta_tags :title => @item.name
    session.delete(:forum_unread)
    render :template => 'shared/show'
  end
  
  
  def update
    @forum = Forum.find(params[:id])
    if @forum.agent == current_agent
      if @forum.update_attributes(forum_params)
        flash[:notice] = 'Your post has been edited.'
      end
    end
    redirect_to @forum
  end
  
  private
  
  def forum_params
    params.require(:forum).permit(:subject, :agent_id, :body, :add_to_newsfeed, userimages_attributes: [:id, :_destroy, :image])
  end
  
end
