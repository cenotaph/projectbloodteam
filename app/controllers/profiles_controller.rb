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
    @profile = Profile.find(params[:id])
    if @profile.agent != current_agent
      flash[:error] = 'This ain\'t your profile, bro.'
    else
      if @profile.update_attributes(profile_params)
        flash[:notice] = 'Your profile has been edited.'
      else
        flash[:error] = 'There was an error saving your profile.'
      end
      redirect_to '/settings'
    end
  end
  
  private
  
  def profile_params
    params.require(:profile).permit(:surname, :age, :location, :missionname, :dateformat, :freetext, :shortfilms, :theme_settings, :defaultcurrency_id, :theme_id)
  end
  
end
