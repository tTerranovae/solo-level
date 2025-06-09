Rails.application.routes.draw do
  resources :questions
  resources :topics
  get "admin/index"
  get "progress/index"
  get "progress/show"
  get "quizzes/index"
  get "quizzes/show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'quizzes#index'
  resources :quizzes, only: [:index, :show] do
    post :submit, on: :member
  end
  resources :progress, only: [:index, :show]
  get 'admin', to: 'admin#index'

  get '/auth/github', to: redirect('/auth/github/callback')
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  delete '/logout', to: 'sessions#destroy', as: :logout
end
