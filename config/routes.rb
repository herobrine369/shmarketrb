Rails.application.routes.draw do
  resources :products
  devise_for :users
  namespace :admin do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"
    resources :products, only: [ :index, :show ] do
      patch :update_status, on: :member
    end
  end
  # Chat endpoint exactly as requested
  get "/chat/:user_id", to: "chats#show", as: :chat

  # For sending messages (nested under conversation)
  resources :conversations, only: [] do
    resources :messages, only: [ :create ]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "welcome#index"
end
