Knojoe::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure', to: redirect('/')
  match '/logout', to: 'sessions#destroy'
  match '/login', to: 'sessions#new'
  match '/logout', to: 'sessions#destroy'

  root to: 'home#index'

  resources :villages, shallow: true do
    member do
      post 'join'
      delete 'quit'
    end

    resources :chats do
      resources :messages, only: :create do
        post 'like', on: :member
        delete 'unlike', on: :member
      end

      member do
        get 'guest'
        get 'villager'
        get 'review'
        post 'connection_timeout'
        post 'chat_timeout'
        post 'finish'
        post 'email'
      end
    end
  end

  resources :users
end
