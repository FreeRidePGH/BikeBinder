# Note:  See all routes with "rake routes"
BikeBinder::Application.routes.draw do
  devise_for :users

  resources :bikes do
    member do
      post 'new_comment'
      get 'qr'
    end
    # resources :departures, :only => [:new]
    collection do 
      get 'available' => 'bikes#index', :defaults => {:status=>'available'}
      get 'assigned' => 'bikes#index', :defaults => {:status=>'assigned'}
      get 'departed'=> 'bikes#index', :defaults => {:status=>'departed'}
      get 'all'=> 'bikes#index', :defaults => {:status=>nil}
    end
  end

  # Bike Actions
  resources :hook_reservations, :only => [:create, :destroy, :update]
  resources :assignments, :only => [:create, :destroy]
  resources :departures, :only => [:create, :destroy]

  resources :hooks, :only =>[:show]
  
  # Search routes
  resources :searches, :only => [:index]

  ####################################################
  ## FINAL ROUTES TO CATCH UNMATCHED URIs AND SEARCHES
  ####################################################
  ####################################################

  # Ensure root is set per recommendations when installing Devise
  root :to => 'bikes#index', :via => [:get, :post], :defaults => {:status=>'available'}

  # Map top level domain seach to bikes and hooks
  match '/:id' => 'bikes#show', :id => BikeNumber.pattern, :via => [:get]
  match '/:id' => 'hooks#show', :id => HookNumber.pattern, :via => [:get]

  ####################################################
  ####################################################
  ## DO NOT ADD ROUTES AFTER THIS LINE
  ####################################################
end
