Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  root to: "books#index"
  resources :books
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    # sessions: 'users/sessions'
  }
  resources :users, :only => %i[index show]
end
