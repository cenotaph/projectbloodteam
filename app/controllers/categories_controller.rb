# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  
  before_filter :authenticate_agent!
  
  def edit  # edit category
    @category = Category.find_by(:agent => Agent.friendly.find(params[:id]), :year =>  getYear)
    if @category.nil?
      
      @category = Category.create(:agent_id => params[:id], :year => getYear)
    end

    if current_agent == @category.agent
      set_meta_tags :title => "Categories for Agent #{@category.agent.surname} in #{getYear}"
      render :template => 'shared/categories/edit'
    else
      flash[:notice] = 'You cannot edit another agent\'s categories.'
      redirect_to '/settings/'
    end
  end
  
  
  def index
    @category = Category.find_by(:agent => current_agent).order('year DESC')
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

 
   
     if @category.update_attributes(category_params)
       flash[:notice] = 'Edited ' + @category.year.to_s + ' categories.'
        redirect_to '/settings'
      else
        flash[:notice] = 'You cannot edit another agent\'s category.'
        redirect_to '/agents/'
      end
    end
  end
  
  private
  
  def category_params
    params.require(:category).permit(:movies, :musics, :books, :bars, :restaurants, :concerts, :events, :eating, :exercise, :weight, :musicplayed, :activities, :airports, :videogames, :groceries, :brewing, :takeaway, :gambling, :tvseries, :year, :miles, :has_movies, :has_musics, :has_books, :has_activities, :has_airports, :has_brewing, :has_concerts, :has_eating, :has_events, :has_exercise, :has_gambling, :has_groceries, :has_miles, :has_musicplayed, :has_restaurants, :has_takeaway, :has_bars, :has_weight, :has_videogames, :has_tvseries)
  end
  
end
