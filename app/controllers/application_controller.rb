# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  include ThemesForRails::ActionController 
  #include AuthenticatedSystem

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :getData
  before_action :getForum
    
  def getTheme
    # if params[:agent_id]
    #   if Profile.where(:agent_id => params[:agent_id]).where(:year => getYear).first.nil?
    #     return 'classic'
    #   else
    #     return Profile.where(:agent_id => params[:agent_id]).where(:year => getYear).first.theme.name
    #   end
    # else
      return 'classic'
    # end
  end
  
  def getView
    if params[:agent_id]
      agent = Agent.friendly.find(params[:agent_id])
      views = View.where(:agent => agent).where(:year => getYear)
      if views.empty?
        @view = View.where(:agent => agent).first
      else
        @view = views.first
      end
    end
  end
  
  def getData
    @active_agents = Profile.where(:year => getYear).includes(:agent).sort_by {|x| x.agent.surname  }
  end
  
  def getForum
      @forums = Comment.includes([:agent, :item ]).paginate_with_items(params[:page], 6)
  
  end
  
  def getYear
     year = request.domain(2)

     if !year.nil? && year.split('.').first =~ /^\d\d\d\d$/
       return year.split('.').first
     else
       return Time.now.strftime('%Y')
     end
   end
   
   protected
   
   def after_sign_in_path_for(resource)
     unless current_agent.discogs_token.blank?
       session[:discogs_token] = Marshal.load(current_agent.discogs_token)
     end
     session[:forum_unread] = Comment.chatter_since_last(resource.last_sign_in_at)
     '/'
   end

   def configure_permitted_parameters
     added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
     devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
     devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
     devise_parameter_sanitizer.permit :account_update, keys: added_attrs
     # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
     # devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
     # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
   end
end
