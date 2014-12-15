# -*- encoding : utf-8 -*-
class CssController < ApplicationController

  before_filter :login_required, :only => [:edit, :update]
  
    # load CSS for an agent
  def show
    profile = Profile.where(:agent_id => params[:id]).where(:year => getYear).first
    @css = profile.theme_settings

    @agent = Agent.find(params[:id])
    respond_to do |format|
      format.css {render :template => 'shared/agent_stylesheet' }
    end
  end

end
