# -*- encoding : utf-8 -*-
class CssController < ApplicationController

  before_filter :login_required, :only => [:edit, :update]
  
    # load CSS for an agent
  def show
    @agent = Agent.find(params[:id])
    profile = Profile.find_by(:agent => @agent, :year => getYear)
    @css = profile.theme_settings

    
    respond_to do |format|
      format.css {render :template => 'shared/agent_stylesheet' }
    end
  end

end
