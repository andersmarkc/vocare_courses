Rails.application.routes.draw do
  # Admin auth — login at /admin/sign_in
  devise_for :admin_users, path: "admin", controllers: {
    sessions: "admin_users/sessions"
  }

  # Admin namespace
  namespace :admin do
    root "dashboard#index"
    resources :tokens, except: [ :edit, :update ] do
      collection { post :batch_generate }
    end
    resources :customers, only: [ :index, :show ]
  end

  # Student API (JSON)
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      get "auth/me", to: "auth#me"

      resources :courses, only: [ :show ], param: :slug
      resources :sections, only: [ :show ]
      resources :lessons, only: [ :show ] do
        resource :progress, only: [ :create ], controller: "progress"
      end
      get "progress/summary", to: "progress#summary"

      resources :quizzes, only: [ :show ] do
        resources :attempts, only: [ :create ], controller: "quiz_attempts"
      end
      resources :quiz_attempts, only: [ :show, :update ]
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Student SPA (React handles client-side routing)
  root "home#index"

  # Catch-all for React Router (must be last)
  get "*path", to: "home#index", constraints: ->(req) {
    !req.path.start_with?("/admin", "/api", "/up", "/rails")
  }
end
