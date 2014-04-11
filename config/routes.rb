Nix::Application.routes.draw do
  get "dashboard/index"

  devise_for :users

  scope "/admin" do
    resources :users, :roles
  end
  post 'suppliers/generate_spot_plan' => 'suppliers#generate_spot_plan', as: :generate_spot_plan
  post 'suppliers/generate_spot_plan_template' => 'suppliers#generate_spot_plan_template', as: :generate_spot_plan_template
  get 'suppliers/upload_spot_plan' => 'suppliers#upload_spot_plan', as: :upload_spot_plan
  get 'projects/:id/assign_user' => 'projects#assign_user', as: :assign_project_user
  post 'projects/:id/start' => 'projects#start', as: :start_project
  get 'projects/:id/assign_user' => 'projects#assign_user', as: :assign_project_user
  post 'projects/:id/save_project_users' => 'projects#save_project_users', as: :save_project_users
  get 'clients/:id/assign_user' => 'clients#assign_user', as: :assign_client_user
  post 'clients/:id/save_client_users' => 'clients#save_client_users', as: :save_client_users
  post 'orders/:id/finish' => 'orders#finish', as: :finish_order
  post 'projects/download_project_info/:id' => 'projects#download_project_info', as: :download_project_info


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
  resources :business_categories do
    resources :suppliers
  end
  resources :clients do
    resources :projects do
      resources :orders
    end
  end
  resources :suppliers,:clients,:projects,:orders,:departments
  resources :business_categories,:web_site_media_reporters
  root to: 'dashboard#index', as: :dashboard

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
