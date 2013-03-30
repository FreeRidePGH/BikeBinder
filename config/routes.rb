# Note:  See all routes with "rake routes"
BikeBinder::Application.routes.draw do
  devise_for :users

  resources :bikes do
    member do
      post 'new_comment'
      get 'qr'
    end
    # resources :departures, :only => [:new]
  end

  # Bike Actions
  resources :hook_reservations, :only => [:create, :destroy, :update]
  resources :assignments, :only => [:create, :destroy]
  resources :departures, :only => [:create, :destroy]

  resources :hooks, :only =>[:show]
  
  # Search routes
  resources :searches, :only => [:index]

  if false
  resources :programs, :except => [:destroy] do
    resources :bikes, :only => [:index]
  end

  resources :destinations, :except => [:destroy] do
    resources :bikes, :only => [:index]
  end
  end

  # Mobile routes
  if false
    # See README for mobile strategy.
    resources :mobile, :only => [:index]
    match '/mobile/filter_bikes' => 'mobile#filter_bikes', :via => [:get]
    match '/mobile/home' => 'mobile#home'
    match '/mobile/find' => 'mobile#find'
    match '/mobile/add' => 'mobile#add'
    match '/mobile/show/:id' => 'mobile#show', :id => BikeNumber.pattern
    match '/mobile/findsubmit' => 'mobile#find_submit'
    match '/mobile/generate_code/:id' => 'mobile#generate_code'
    match '/mobile/upload' => 'mobile#upload', :via => [:get,:post]
    match '/mobile/ajax_show/:id' => 'mobile#ajax_show'
    match '/mobile/ajax_find' => 'mobile#ajax_find', :via => :get
    match '/mobile/ajax_add' => 'mobile#ajax_add', :via => :get
  end

  ####################################################
  ## FINAL ROUTES TO CATCH UNMATCHED URIs AND SEARCHES
  ####################################################
  ####################################################

  # Ensure root is set per recommendations when installing Devise
  root :to => 'bikes#index', :via => [:get, :post]

  # Map top level domain seach to bikes and hooks
  match '/:id' => 'bikes#show', :id => BikeNumber.pattern, :via => [:get]
  match '/:id' => 'hooks#show', :id => HookNumber.pattern, :via => [:get]

  ####################################################
  ####################################################
  ## DO NOT ADD ROUTES AFTER THIS LINE
  ####################################################
end
