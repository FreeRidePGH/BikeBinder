BikeBinder::Application.routes.draw do

  # Note:  See all routes with "rake routes"

  resources :programs, :except => [:destroy]

  # access to projects without nesting in programs
  resources :projects, \
  :only => [:show, :index, :edit, :update, :create, :new, :delete, :destroy], \
  :path_names => {:new=>'start', :delete=>'cancel'} do
    member do
      post 'new_comment'
      get 'finish'
      put 'close'
      put 'transition'
    end

    resources :work_log, :path_names => {:new => 'enter'}
  end

  resources :project_categories, :except=>[:destroy, :new, :create]

  devise_for :users

  resources :bikes,:except => [:destroy] do
    member do
      post 'new_comment'
      put 'vacate_hook'
      put 'reserve_hook'
      get 'depart'
      put 'send_away'
      put 'change_hook'
    end
  end

  resources :hooks,:except =>[:destroy, :new, :create]

  # Ensure root is set per recommendations when installing Devise
  root :to => 'bikes#index', :via => [:get]

  # Map top level domain seach to bikes and hooks
  match '/:id' => 'bikes#show', :id => Bike.number_pattern, :via => [:get]
  match '/:id' => 'hooks#show', :id => Hook.number_pattern, :via => [:get]
end
