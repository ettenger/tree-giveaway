Rails.application.routes.draw do
  resources :logos
#  get 'stored_text/edit'

#  get 'stored_text/update'

#  get 'stored_text/update'

#  get 'stored_text/edit'

#  mount Ckeditor::Engine => '/ckeditor'
#  get 'request/create'

#  get 'request/destroy'

  get 'requests/index/:id', to: 'requests#index'
  get 'login', to: 'sus#login', as: :login
  post 'login', to: 'sus#update'
  get 'logout', to: 'sus#clear', as: :logout
  get 'su/home', to: 'sus#home', as: :su_home

#  get 'request/show'
  resources :requests do
    collection do
      get 'delete_all'
    end
  end

  resources :giveaways do
    member do
      get 'duplicate'
      get 'links'
    end
  end

  resources :trees do
    member do
      patch 'update_order'
    end
  end

  resources :giveaways
  resources :trees
  resources :requests
  resources :stored_text, :only => [:edit, :update]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
