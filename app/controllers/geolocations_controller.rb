# -*- encoding : utf-8 -*-
class GeolocationsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate_agent!, :only => [:new, :edit, :update, :create, :destroy]
  
  #caches_page :index 

  def create
    @geolocation = Geolocation.new(params[:geolocation])
    if @geolocation.save
      flash[:notice] = 'Location saved.'
      redirect_to '/'
    end

  end
  
  def destroy
    @geolocation = Geolocation.find(params[:id])
    @geolocation.destroy!
    redirect_to '/'
  end
  
  def edit
    set_meta_tags :title => 'Edit geolocation data'
    @geolocation = Geolocation.find(params[:id])
    @others = Geolocation.where(latitude: @geolocation.latitude, longitude: @geolocation.longitude).to_a.delete_if {|x| x == @geolocation }
  end
  
  def index
    # if FileTest.exists?("#{Rails.root}/tmp/cache/pbt_world.json")
    #   @json = File.read("#{Rails.root}/tmp/cache/pbt_world.json")
    # else
      @json = Geolocation.all
      # File.open("#{Rails.root}/tmp/cache/pbt_world.json", 'w') do |f|
        # f.puts @json
      # end
    # end
  end
  
  def merge
    locations = [Geolocation.find(params[:id]), Geolocation.find(params[:second_id]) ].sort_by{|x| x.pbt_entries.size }.reverse
    removing = locations.last
    original = locations.first
    removing.pbt_entries.each do |entry|
      entry.geolocation = original
      entry.save
    end
    removing.destroy!
    redirect_to original
  end
    
  def show
    @geolocation = Geolocation.find(params[:id])
    @json = @geolocation
    set_meta_tags title: @geolocation.address
  end
  
  def update
    @geolocation = Geolocation.find(params[:id])
    unless params[:geolocation][:address].nil?
      @others = Geolocation.find_by_address(params[:geolocation][:address])
      if @others.nil? || @others.id.to_s == params[:id]
        if @geolocation.update_attributes(geolocation_params)
          flash[:notice] = 'Location updated.'
          # expire_page :action => :index
          redirect_to @geolocation
        end
      else
        if @others.latitude == params[:geolocation][:latitude] && @others.longitude == params[:geolocation][:longitude]
          @geolocation.pbt_entries.each do |entry|
            entry.geolocation_id = @others.id
            entry.save!
          end
          # expire_page :action => :index
          flash[:notice] = 'Changed data for ' + @geolocation.pbt_entries.size + ' items'
          @geolocation.destroy!
        else
          flash[:warning] = 'There is another entry with the same address but different coordinates, please check.'
          update! { '/' }
        end
      end
    else
      flash[:error] = 'You must enter an address.'
      redirect_to '/'
    end
  end
  
  protected
  
  def geolocation_params
    params.require(:geolocation).permit([:address, :latitude, :longitude ] )
  end

end