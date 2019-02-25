# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController
  respond_to :html, :xml
  before_action :authenticate_agent!, :only => [:new, :edit, :update, :create, :destroy]
  
  def destroy
    session[:stored] = URI(request.referer).path
    # expire_fragment(/.*newsfeed_front.*/)
    @entry = Entry.find(params[:id])
    if @entry.agent == current_agent
      @entry.destroy!
    end
    redirect_to session[:stored]
  end

end
