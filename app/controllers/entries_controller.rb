# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController
  respond_to :html, :xml
  before_filter :login_required, :only => [:new, :edit, :update, :create, :destroy]
  
  def destroy
    expire_fragment(/.*newsfeed_front.*/)
    destroy! { '/' }
  end

end
