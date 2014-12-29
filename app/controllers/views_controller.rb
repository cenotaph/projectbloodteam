# -*- encoding : utf-8 -*-
class ViewsController < ApplicationController
  
  before_filter :authenticate_agent!
  
  def edit  # edit view
    @view = View.where(:agent_id => current_agent.id).where(:year => getYear).first
    if @view.nil?
      @view = View.create(:agent_id => current_agent.id, :year => getYear)
    end
    if current_agent == @view.agent
      render :template => 'shared/views/edit'
    else
      flash[:notice] = 'You cannot edit another agent\'s views.'
      redirect_to '/settings/'
    end
    set_meta_tags :title => 'Editing column names'
  end
  
  
  def index
    @view = View.where(:agent_id => current_agent.id).order('year DESC').first
   render :layout => getTheme(current_agent.id  getYear), :template => getTheme(params[:id], getYear) + '/view'
  end
    
  
  def show
    index
  end
    
    
  def update
     @view = View.find(params[:id])
     @view.agent = current_agent
    # @view.year = params[:view][:year]
    logger.warn('before : ' + params.inspect)
     params[:view].each do |p|
       if p[0] =~ /^has/
         if p[1] == '0'
            params['view'][p[0].sub(/^has/,'')] = '0'
         else
            params['view'][p[0].sub(/^has/, '')] = params[:view][p[0].sub(/^has/, '')]
         end
         params[:view].delete(p[0])
        end
     end
 
   logger.warn('after : ' + params.inspect)
   
     if @view.update_attributes(params[:view].permit!)
       flash[:notice] = 'Edited ' + @view.year.to_s + ' view.'
       redirect_to '/settings/'
      else
        flash[:notice] = 'You cannot edit another agent\'s view.'
        redirect_to '/settings/'
      end
    end
  
end
