# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  
  before_filter :login_required
  
  def edit  # edit category
    @category = Category.where(:agent_id => params[:id]).where(:year =>  getYear).first
    if @category.nil?
      @category = Category.create(:agent_id => params[:id], :year => getYear)
    end
    if current_agent == @category.agent
      render :template => 'shared/categories/edit'
    else
      flash[:notice] = 'You cannot edit another agent\'s categories.'
      redirect_to '/agents/'
    end
  end
  
  
  def index
    @category = Category.find(:first, :conditions => ['agent_id = ?', current_agent.id], :order => 'year DESC')
    render :layout => getTheme(current_agent.id, getYear), :template => getTheme(params[:id], getYear) + '/agents/category'
  end
    
  
  def show
    index
  end
    
    
  def update
    @category = Category.find(params[:id])
    if @category.agent != current_agent
      flash[:error] = 'This ain\'t your categories, bro.'
    else
     params[:category].each do |p|
       if p[0] =~ /^has/
         if p[1] == '0'
            params['category'][p[0].sub(/^has_/,'')] = '0'
         else
            params['category'][p[0].sub(/^has_/, '')] = params[:category][p[0].sub(/^has_/, '')]
         end
         params[:category].delete(p[0])
        end
     end
 
   
     if @category.update_attributes(params[:category])
       flash[:notice] = 'Edited ' + @category.year.to_s + ' category.'
        redirect_to '/settings'
      else
        flash[:notice] = 'You cannot edit another agent\'s category.'
        redirect_to '/agents/'
      end
    end
  end
end
