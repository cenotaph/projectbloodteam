# -*- encoding : utf-8 -*-
class CssController < ApplicationController

  before_action :login_required, :only => [:edit, :update]
  
    # load CSS for an agent
  def show
    @agent = Agent.find(params[:id])
    profile = Profile.find_by(:agent => @agent, :year => getYear)
    if profile.nil?
      render plain: ''
    else
      @css = profile.theme_settings
      respond_to do |format|
        format.css {render :template => 'shared/agent_stylesheet' }
      end
    end
  end

end
