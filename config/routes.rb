Knojoe::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure', to: redirect('/')
  match '/logout', to: 'sessions#destroy'
  match '/login', to: 'sessions#new'
  match '/logout', to: 'sessions#destroy'

  root to: 'home#index'

  resources :chats do
    resources :messages, only: :create

    get 'guest', on: :member
    get 'villager', on: :member
  end

  resources :users
end
