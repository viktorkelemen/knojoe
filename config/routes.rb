Knojoe::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get '/auth/failure', to: redirect('/')
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'

  root to: 'home#index_static', constraints: ->(req) { req.session[:user_id].blank? }
  root to: 'home#index'

  get 'home/hook'
  post 'pusher/auth'

  resources :chats, only: [:new, :create], shallow: true do
    resources :messages, only: :create do
      post 'like', on: :member
      delete 'unlike', on: :member
    end

    member do
      get 'requester'
      get 'responder'
      get 'review'
      post 'connection_timeout'
      post 'chat_timeout'
      post 'finish'
      post 'email'
      post 'status'
    end
  end

  resources :users, only: [:index, :show] do
    member do
      get 'asked'
      get 'helped'
    end
  end

end
