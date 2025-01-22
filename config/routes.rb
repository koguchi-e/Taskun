Rails.application.routes.draw do

  # 管理者権限のルーティング
  devise_for :admin,skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  namespace :admin do
    get "dashboards", to: "dashboards#index"
    resources :users, only: [:destroy]
  end

  ################################################################

  scope module: :public do
    devise_for :users, controllers: {
      registrations: 'public/registrations'
    }
    root to: "homes#top"
    get 'about', to: 'homes#about', as: 'about'

    get 'search', to: 'tasks#search'

    # tasksコントローラのルーティング
    resources :tasks, only: [:new, :create, :index, :show, :edit, :update, :destroy]

    # usersコントローラのルーティング
    resources :users, only: [:index, :show, :edit, :update] do
      # withdrawアクション（退会処理）
      member do
        patch :withdraw # PATCHリクエストで退会処理を実行
      end
    end
  end
end
