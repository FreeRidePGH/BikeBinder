def resources_project_work_log
  resources :work_log, :path_names => {:new => 'enter'}, :only => [:new, :create],
  :controller=>'project_time_entries'
end

BikeBinder::Application.routes.draw do

  # Note:  See all routes with "rake routes"

  resources :programs, :except => [:destroy]

  # access to projects without nesting in programs
  resources :projects, \
  :only => [:show, :edit, :update, :create, :new, :delete, :destroy], \
  :path_names => {:new=>'start', :delete=>'cancel'} do
    member do
      post 'new_comment'
      put 'transition'
      get 'finish'
      put 'close'
    end

    resources_project_work_log
  end

  resources :project_categories, :except=>[:destroy, :new, :create]

  devise_for :users

  resources :bikes,:except => [:destroy] do
    member do
      post 'new_comment'
      put 'vacate_hook'
      put 'reserve_hook'
      put 'change_hook'
      get 'depart'
    end
  end

  resources :hooks,:except =>[:destroy, :new, :create]

  # Ensure root is set per recommendations when installing Devise
  root :to => 'bikes#index', :via => [:get]

  # Map top level domain seach to bikes and hooks
  match '/:id' => 'bikes#show', :id => Bike.number_pattern, :via => [:get]
  match '/:id' => 'hooks#show', :id => Hook.number_pattern, :via => [:get]
end
