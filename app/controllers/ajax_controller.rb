# -*- encoding : utf-8 -*-
class AjaxController < ApplicationController

  
  def geolocations
    cat = params[:category].classify.constantize
    va = [Event, Movie, Activity, Musicplayed, Tvseries]
    if cat == Event || cat == Movie || cat == Activity || cat == Musicplayed || cat == Tvseries
      items = cat.joins(:geolocation_item).where('location like "%' + params[:term] + '%" and geolocation_items.id IS NOT NULL').group(:geolocation_id, :venue_address)
    elsif cat == Concert      
      items = cat.joins(:geolocation_item).where('venue like "%' + params[:term] + '%" and geolocation_items.id IS NOT NULL').group(:geolocation_id, :venue_address)
    elsif cat == Brewing
      items = cat.joins(:geolocation_item).where('location like "%' + params[:term] + '%" and geolocation_items.id IS NOT NULL')
    else
      items = cat.joins(:geolocation_item).where('name like "%' + params[:term] + '%" and geolocation_items.id IS NOT NULL') #.group(:geolocation_id)
    end
    items = items.to_a.delete_if{|u| u.geolocation_items.empty? }
    list = items.map{|u| Hash["id" => u.id, "label" => (va.include?(cat) ? u.location + " [" + u.geolocation.address.to_s + "]" : (cat == Concert ? u.venue + " [" + u.geolocation.address.to_s + "]" : u.name + " [" + u.location + "]")), "name" =>  (va.include?(cat) ? u.location  : (cat == Concert ? u.venue : ((cat == Movie || cat == Activity || cat == Event  || cat == Tvseries || cat == Musicplayed) ? u.location : u.name))), "lat" => u.geolocation.latitude, "lng" => u.geolocation.longitude, "geolocation_id" => u.geolocation_id, "address" => u.geolocation.address]}

    render :json => list.uniq(&:geolocation_id)
  end
  
end
