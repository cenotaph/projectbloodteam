Pbt4::Application.routes.draw do 
  devise_for :agents
  
  devise_scope :agent do
    match 'login' => 'devise/sessions#new', :as => :login, via: :get
    match 'logout' => 'devise/sessions#destroy', :as => :logout, via: :delete
  end
  
  themes_for_rails

  match '/settings', :controller => 'agents', :action => :your_settings, via: :get
  match '/agents/rss/:id.:format', :controller => 'agents', :action => 'rss', via: :get
  match '/agents/rss/:id/:password.:format', :controller => 'agents', :action => 'rss', via: :get
  match '/missing_profile', :controller => :home, :action => :missing_profile, via: :get
  match '/search/simple', :controller => 'search', :action => 'simple', via: :post
  resources :stats do
    collection do
      get :gbp
      post :gbp
    end
  end
  resources :css
  resources :geolocations
  get "ajax/geolocations"
  resources :agents do

    member do
      get :history
    end
    
    resources :activities, :controller => :generic, :category => 'Activity'
    resources :airports, :controller => :generic, :category => 'Airport'
    resources :bars, :controller => :generic, :category => 'Bar'
    resources :brewing, :controller => :generic, :category => 'Brewing', :path => 'brewing'
    resources :concerts, :controller => :generic, :category => 'Concert'
    resources :eating, :controller => :generic, :category => 'Eating', :path => 'eating'
    resources :events, :controller => :generic, :category => 'Event'
    resources :exercises, :controller => :generic, :category => 'Exercise', :path => 'exercise'
    resources :gambling, :controller => :generic, :category => 'Gambling'
    resources :groceries, :controller => :generic, :category => 'Grocery'
    resources :miles, :controller => :generic, :category => 'Mile'
    resources :musicplayed, :controller => :generic, :category => 'Musicplayed', :path => 'musicplayed'
    resources :restaurants, :controller => :generic, :category => 'Restaurant'
    resources :takeaway, :controller => :generic, :category => 'Takeaway', :path => 'takeaway'
    resources :weights, :controller => :generic, :category => 'Weight', :path => 'weight'
    resources :forums
    
    resources :tvseries, :controller => :genericmaster, :category => 'Tvseries' do
      collection do
        get :query
        get :directid
      end
    end
    
    resources :master_tvseries, :controller => :genericmaster, :category => 'MasterTvseries'
    
    resources :movies, :controller => :genericmaster, :category => 'Movie' do
      collection do
        get :query
        get :shorts
        get :directid
      end
    end
    resources :master_movies, :controller => :genericmaster, :category => 'MasterMovie'
    
    resources :musics, :controller => :genericmaster, :category => 'Music' do
      collection do
        get :query
        get :unreviewed
        get :unreviewedlp
        get :needs_new_review
        get :directid
      end
    end
    resources :master_musics, :controller => :genericmaster, :category => 'MasterMusic'
  
    resources :books, :controller => :genericmaster, :category => 'Book' do
      collection do
        get :query
      end
    end
    resources :master_books, :controller => :genericmaster, :category => 'MasterBook'
    
    resources :videogames, :controller => :genericmaster, :category => 'Videogame' do
      collection do
        get :query
      end
    end
    resources :master_videogames, :controller => :genericmaster, :category => 'MasterVideogame'
    
    resources :profiles
    resources :comments, :controller => :generic, :category => 'Comment'
  end
  
  
  resources :generics do
    get :autocomplete

    member do
      match  '/aggregate/:category', :to =>  "generic#aggregate", :as => :aggregate, via: :get
    end
  end
  
  resources :genericmaster do
    collection do
      match '/custom/:category/:followup', :to => "genericmaster#custom_master", :as => :custom_master, via: :get
      match '/create_custom/:category', :to  => "genericmaster#create_master", :as => :create_master, via: :post
    end
    member do
      match '/edit_master/:category', :to => "genericmaster#edit_master", :as => :edit_master, via: :get
      match '/select/:agent_id/:category/', :to => "genericmaster#select", :as => :select, via: :get
      match  '/aggregate_creators/:category', :to =>  "genericmaster#aggregate_creators", :as => :aggregate_creators, via: :get
    end
  end
  
  resources :activities, :controller => :generic, :category => 'Activity'
  resources :airports, :controller => :generic, :category => 'Airport'
  resources :bars, :controller => :generic, :category => 'Bar'
 
  resources :brewings, :controller => :generic, :category => 'Brewing', :path => 'brewing'
  resources :concerts, :controller => :generic, :category => 'Concert'
  resources :eatings, :controller => :generic, :category => 'Eating', :path => 'eating'
  resources :events, :controller => :generic, :category => 'Event'
  resources :exercises, :controller => :generic, :category => 'Exercise', :path => 'exercise'
  resources :gambling, :controller => :generic, :category => 'Gambling'
  resources :groceries, :controller => :generic, :category => 'Grocery'
  resources :miles, :controller => :generic, :category => 'Mile'
  resources :musicplayeds, :controller => :generic, :category => 'Musicplayed', :path => 'musicplayed'
  resources :restaurants, :controller => :generic, :category => 'Restaurant'
  resources :takeaway, :controller => :generic, :category => 'Takeaway', :path => 'takeaway'
  resources :weight, :controller => :generic, :category => 'Weight'
  
  resources :movies, :controller => :genericmaster, :category => 'Movie'
  resources :master_movies, :controller => :genericmaster, :category => 'MasterMovie'
  resources :musics, :controller => :genericmaster, :category => 'Music' do
    collection do
      get :authenticate
      get :callback
    end
  end
  
  resources :master_musics, :controller => :genericmaster, :category => 'MasterMusic'
  resources :books, :controller => :genericmaster, :category => 'Book'
  resources :master_books, :controller => :genericmaster, :category => 'MasterBook'
  resources :videogames, :controller => :genericmaster, :category => 'Videogame'
  resources :master_videogames, :controller => :genericmaster, :category => 'MasterVideogame'
  resources :tvseries, :controller => :genericmaster, :category => 'Tvseries'
  resources :master_tvseries, :controller => :genericmaster, :category => 'MasterTvseries'
  
  resources :forums, :has_many => :comments
  resources :comments, :controller => :generic, :category => 'Comment'
  resources :entries
  resources :profiles
  resources :categories
  resources :views



  root :to => "home#index"


end
