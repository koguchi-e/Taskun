Rails.application.routes.draw do

  devise_for :users
  root to: "homes#top"

  # tasksコントローラのルーティングまとめて書く。
  resources :tasks, only: [:new, :create, :index, :show, :edit, :update, :destroy]  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'about', to: 'homes#about', as: 'about'
end
