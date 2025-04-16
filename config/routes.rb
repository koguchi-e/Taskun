Rails.application.routes.draw do
  get 'event_notices/new'
  get 'event_notices/create'
  get 'event_notices/sent'
  devise_for :admins, skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  namespace :admin do
    resources :users, only: [:destroy]
    resources :dashboards, only: [:index] do
      collection do
        get :search
      end
    end
    resources :comments, only: [:index, :destroy]
    resources :tasks, only: [:index, :destroy]
  end

  ################################################################

  scope module: :public do
    root to: "homes#top"
    get "about", to: "homes#about", as: "about"
    get "search", to: "tasks#search"

    devise_for :users, controllers: {
      registrations: "public/registrations",
    }

    resources :tasks, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resources :task_comments, only: [:create, :destroy]
      member do
        patch :complete  
        patch :incomplete  
      end
    end

    resources :users, only: [:index, :show, :edit, :update] do
      member do
        patch :withdraw
      end
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end

    resources :groups, only: [:new, :create, :index, :edit, :update, :show, :destroy] do
      collection do
        get "about"
      end
      member do
        post "join", to: "groups#join"
        delete "leave", to: "groups#leave"
      end
      resources :event_notices, only: [:new, :create]
      get "event_notices" => "event_notices#sent"
    end

    resources :notifications, only: [:update]
  end
end
