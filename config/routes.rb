TestApp::Application.routes.draw do
  #get "sessions/new"
  match '/sessions/signin', :controller => 'sessions', :action => 'signin'

  match  'destroy_session',      :to => 'sessions#destroy'
  match  '/create_listing/',     :to => 'userlistings#create'
  match  '/new_listing',         :to => 'userlistings#new'
  match  '/exchange_listing/',   :to => 'userlistings#show_listing_exchange'
  match  'show_listing/',        :to => 'userlistings#show_listing_result'
  #match  '/quicksale/:id',       :to => 'needs#quicksale'
  #match  '/share/:id',           :to => 'needs#share'
  #match  '/list_offer/:id',      :to => 'offers#new'
  match  '/profile/:id',         :to => 'users#profile'
  match  '/user_exchanges/:id',  :to => 'users#exchanges'
  match  '/messages/:id',        :to => 'users#messages'
  match  '/view/:id',            :to => 'users#view'
  match  '/signup/',             :to => 'users#new'
  match  '/signup/:email&:pass', :to => 'users#new'
  match  '/users/:id/offers',    :to => 'users#offers'
  match  '/users/:id/needs/',    :to => 'users#needs'
  match  '/users/:id/need/:listing', :to => 'users#get_need'
  match  '/users/:id/offer/:listing', :to => 'users#get_offer'
  #match  '/users/:id', :to => 'users#show', :as => 'profile'
  match  '/search/',           :to => 'search#search'
  match  '/initiate_exchange/', :to => 'exchanges#initiate_exchange'
  match  '/create_exchange/', :to => 'exchanges#create'
  match  '/accept_exchange/', :to => 'exchanges#accept_exchange', :as => 'accept_exchange'
  match  '/accept_perform/' , :to => 'exchanges#accept_perform' , :as => 'accept_perform'
  match  '/rate_exchange/'  , :to => 'exchanges#rate_exchange' , :as => 'rate_exchange'
  match  '/add_offer/',   :to => 'exchanges#add_offer'
  match  '/add_need/',   :to => 'exchanges#add_need'
  match  '/sendmessage/', :to => 'messages#new'
  match  '/mark_unread/', :to => 'messages#markAsUnread'
  match  '/mark_read/', :to => 'messages#markAsRead'
  put '/userlisting/:id', :to => 'userlistings#update'
  get  '/edit_listing/',  :to => 'userlistings#edit'
  get  '/sendmessage/?id=:id&replyTo=:reply_message_id'    , :to => 'messages#new'
  # Forgot password and password reset hacks
  get '/forgot/', :to => 'users#forgot'
  post '/forgot', :to => 'users#process_forgot'
  get '/resetpassword/', :to => 'users#reset_password'
  post '/resetpassword/', :to => 'users#process_reset_password'
  get '/activate/', :to => 'users#activate'
  #match '/signout', :to => 'sessions#destroy'
  #match '/home', :to => 'pages#index'

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
  root :to => 'sessions#index'
  resources :userlistings
  resources :search
  resources :users do |user|
    resources :userlistings
    resources :profiles
  end
  resources :sessions#, :only => [:new, :create, :destroy]
  resources :exchanges
  resources :profiles
  resources :messages


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
