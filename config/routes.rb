Rails.application.routes.draw do
  get '/auth/:provide/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#auth_fail'
  get '/sign_out', to: 'sessions#destroy', as: :sign_out

  resources :comments, only: [:new, :create, :index]
  root to: 'comments#new'
end
