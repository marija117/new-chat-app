Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  resources :messages, :controller => "message"

  root 'message#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
