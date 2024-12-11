# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :users do
      post :sign_in, to: 'sessions#create'
      post :sign_up, to: 'registrations#create'
      post :confirm, to: 'registrations#confirm'
    end

    resources :companies do
      put :restore, on: :member
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
