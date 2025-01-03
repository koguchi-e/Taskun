Rails.application.routes.draw do

  # 管理者権限のルーティング
  devise_for :admin,skip: [:registrations, :password], controllers: {
    sessions: "admin/sessions"
  }

  # ログアウトのメソッドをDLETEに変換
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  namespace :admin do
    get "dashboards", to: "dashboards#index"
    resources :users, only: [:destroy]
  end

  ################################################################

  scope module: :public do
    devise_for :users
    root to: "homes#top"
    get 'about', to: 'homes#about', as: 'about'

    # tasksコントローラのルーティングまとめて書く。
    resources :tasks, only: [:new, :create, :index, :show, :edit, :update, :destroy]

    # usersコントローラのルーティングまとめて書く。
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end
end
