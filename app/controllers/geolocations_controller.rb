# -*- encoding : utf-8 -*-
class GeolocationsController < InheritedResources::Base
  respond_to :html, :xml
  before_filter :login_required, :only => [:new, :edit, :update, :create, :destroy]
  
  #caches_page :index 

  def create
   # expire_page :action => :index
    super
  end
  
  def index
    # if FileTest.exists?("#{Rails.root}/tmp/cache/pbt_world.json")
    #   @json = File.read("#{Rails.root}/tmp/cache/pbt_world.json")
    # else
      @json = Geolocation.all.to_gmaps4rails
      # File.open("#{Rails.root}/tmp/cache/pbt_world.json", 'w') do |f|
        # f.puts @json
      # end
    # end
  end
  
  def show
    @geolocation = Geolocation.find(params[:id])
    @json = @geolocation.to_gmaps4rails
  end
  
  def update
    @geolocation = Geolocation.find(params[:id])
    unless params[:geolocation][:address].nil?
      @others = Geolocation.find_by_address(params[:geolocation][:address])
      if @others.nil? || @others.id.to_s == params[:id]
        if @geolocation.update_attributes(params[:geolocation])
          flash[:notice] = 'Location updated.'
          expire_page :action => :index
          redirect_to @geolocation
        end
      else
        if @others.latitude == params[:geolocation][:latitude] && @others.longitude == params[:geolocation][:longitude]
          @geolocation.pbt_entries.each do |entry|
            entry.geolocation_id = @others.id
            entry.save!
          end
          expire_page :action => :index
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
        
end