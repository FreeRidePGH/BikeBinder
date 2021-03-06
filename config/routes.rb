# Note:  See all routes with "rake routes"
BikeBinder::Application.routes.draw do
  devise_for :users

  resources :bikes do
    member do
      post 'new_comment'
      get 'qr'
    end
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
  resources :pages, :only => [:index, :show]

  ####################################################
  ## FINAL ROUTES TO CATCH UNMATCHED URIs AND SEARCHES
  ####################################################
  ####################################################

  # Ensure root is set
  # root :to => 'bikes#index', :via => [:get, :post], :defaults => {:status=>'available'}
  root :to => 'pages#index', :via => [:get, :post]

  # Map top level domain seach to bikes and hooks
  get '/:id' => 'bikes#show', :id => BikeNumber.pattern
  get '/:id' => 'hooks#show', :id => HookNumber.pattern

  ####################################################
  ####################################################
  ## DO NOT ADD ROUTES AFTER THIS LINE
  ####################################################
end
