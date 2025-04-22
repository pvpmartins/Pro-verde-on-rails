Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "users/plans#index"

  inertia 'unauthorized' => 'Admin/Unauthorized'

  resources :products, only: [:index, :show]

  resources :plans do
    resources :plan_versions, only: [:index, :new, :create] 

    member do
      get :go_to_plan
    end
  end

  namespace :users do
    resources :plans do
      member do
        post :create_checkout_session
        get :success
        get :cancel
      end
    end
    resources :subscriptions
  end

  namespace :admin do
    resources :roles do
      resources :permissions, only: [:edit, :update]
      resources :role_users, only: [:create, :destroy]  # To assign users to roles
    end

    resources :users, only: [:index, :show]
    resources :products
    resources :subscriptions
  end


  resources :plan_versions, only: [:edit, :update, :destroy]
end
