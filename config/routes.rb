Knojoe::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure', to: redirect('/')
  match '/logout', to: 'sessions#destroy'
  match '/login', to: 'sessions#new'
  match '/logout', to: 'sessions#destroy'

  root to: 'villages#index'

  resources :villages, shallow: true do
    resources :participations, only: [:create, :destroy]

    resources :chats do
      resources :messages, only: :create

      get 'guest', on: :member
      get 'villager', on: :member
    end
  end

  resources :users
end
