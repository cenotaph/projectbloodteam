# -*- encoding : utf-8 -*-
class ProfilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_agent!, :only => [:new, :edit, :update, :create, :destroy]
  
  def create
    @profile = Profile.create(params[:profile])
    if @profile.save
      category = Category.create(:agent_id => @profile.agent_id, :year => @profile.year)
      views = View.create(:agent_id => @profile.agent_id, :year => @profile.year)
      flash[:notice] = 'Thank you for creating your profile.'
      redirect_to '/'
    else
      flash[:error] = 'Error creating profile: ' + @profile.errors.full_messages.join('; ')
      render :template => 'shared/profiles/new'
    end
  end
  
  def edit  # edit profile

    @profile = Profile.find(params[:id])
    if current_agent == @profile.agent
      @profile.deliciouspw = @profile.deliciouspw.tr("A-Ma-mN-Zn-z","N-Zn-zA-Ma-m") if @profile.deliciouspw
      render :template => 'shared/profiles/edit'
    else
      flash[:notice] = 'You cannot edit another agent\'s profile.'
      redirect_to '/settings/'
    end
  end
  
  def update
    update! { '/settings' }  
  end
  
  
end
