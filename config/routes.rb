Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  resources :rooms do
    resources :messages, :controller => "message", only: [ :create ]
  end
  get "rooms/:id/old_messages", to: "rooms#load_old_messages", as: 'old_messages'

  

  root 'rooms#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
