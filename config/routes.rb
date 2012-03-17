BikeBinder::Application.routes.draw do

  resources :programs, :except => [:destroy] do
    resources :projects,\
    :except => [:destroy, :edit, :update], :path_names => {:new=>'start'}
  end

  # access to projects without nesting in programs
  resources :projects, :only => [:show, :index, :edit, :update]

  devise_for :users

  resources :bikes,:except => [:destroy] do
    member do
      post 'new_comment'
      put 'vacate_hook'
      put 'reserve_hook'
    end
  end

  # May want to use the friendly_id gem and let hook number be a string
  # in similar fashion to the bike routing. Would be an alternative
  # to having the constraints on id
  resources :hooks,\
  :except =>[:destroy, :new],\
  :constraints => {:id => /\d{3}/}

  # Ensure root is set per recommendations when installing Devise
  root :to => 'bikes#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
