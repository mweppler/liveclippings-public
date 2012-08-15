LiveclippingsFront::Application.routes.draw do

  root :to => 'pages#home'

  match '/about', :to => 'pages#about'
  match '/clipping/copy/:id',    :to => 'clippings#copy'
  match '/clipping/create',      :to => 'clippings#create'
  match '/clipping/delete/:id',  :to => 'clippings#delete'
  match '/clipping/destroy/:id', :to => 'clippings#destroy'
  match '/clipping/edit/:id',    :to => 'clippings#edit'
  match '/clipping/new',         :to => 'clippings#new'
  match '/clipping/show/:id',    :to => 'clippings#show'
  match '/clipping/update/:id',  :to => 'clippings#update'
  match '/clippings',            :to => 'clippings#list'
  match '/clippings/page/:page', :to => 'clippings#list'
  match '/clippings/search/:search',            :to => 'clippings#list'
  match '/clippings/search/:search/page/:page', :to => 'clippings#list'
  match '/contact',         :to => 'pages#contact'
  match '/feedback',        :to => 'pages#feedback'
  match '/follow/:id',      :to => 'followings#follow'
  match '/followings',      :to => 'followings#followings'
  match '/forgot_password', :to => 'pages#forgot_password'
  match '/help',            :to => 'pages#help'
  match '/login',           :to => 'access#attempt_login'
  match '/password_reset/:id',  :to => 'pages#password_reset'
  match '/profile',             :to => 'users#show'
  match '/profile/edit/:id',    :to => 'users#edit'
  match '/profile/delete/:id',  :to => 'users#delete'
  match '/profile/destroy/:id', :to => 'users#destroy'
  match '/profile/update/:id',  :to => 'users#update'
  match '/search',            :to => 'followings#search'
  match '/signin',            :to => 'access#login'
  match '/signout',           :to => 'access#logout'  
  match '/signup',            :to => 'users#new'
  match '/signup/create',     :to => 'users#create'
  match '/stream',            :to => 'clippings#stream'
  match '/stream/page/:page', :to => 'clippings#stream'
  match '/unfollow/:id',      :to => 'followings#delete'


  # LiveClippings API Routes
  # namespace :api, defaults: { format: 'json' } do
  #   namespace :v1 do
  #     resources :clippings
  #   end
  # end


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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end