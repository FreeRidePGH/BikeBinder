def resources_project_work_log
  resources :work_log, :path_names => {:new => 'enter'}, :only => [:new, :create],
  :controller=>'project_time_entries'
end

BikeBinder::Application.routes.draw do

  # Note:  See all routes with "rake routes"

  resources :programs, :except => [:destroy] do
    resources :bikes, :only => [:index]
  end

  resources :destinations, :except => [:destroy] do
    resources :bikes, :only => [:index]
  end

  devise_for :users

  resources :bikes do
    member do
      post 'new_comment'
      get 'qr'
    end
    resources :departure, :only => [:new]
  end

  resources :hooks, :only =>[:index, :show]

  resources :hook_reservations, :except => [:index, :show]
             
  resources :assignments, :only => [:create, :update, :destroy]

  resources :departures, :only => [:new, :create, :destroy]
            

  # Search routes
  resources :searches, :only => [:index]

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


  # AJAX Routes
  match '/bikes/get_models/:brand_id' => 'bikes#get_models'
  match '/bikes/get_brands/:bike_model_id' => 'bikes#get_brands'
  match '/bikes/filter_bikes/:id' => 'bikes#filter_bikes'
  match '/bikes/get_details/:id' => 'bikes#get_details'

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
