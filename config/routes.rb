Rails.application.routes.draw do
  post '/view_followers', to: 'users#view_followers'
  root to: 'users#index'
  resources :users
end
