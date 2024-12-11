# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :users do
      post :sign_in, to: 'sessions#create'
      post :sign_up, to: 'registrations#create'
      post :confirm, to: 'registrations#confirm'
    end

    resources :companies do
      put :restore, on: :member
      resources :surveys, only: [:create], module: :companies do
        resources :invites, only: [:create], module: :surveys
        resources :responses, only: [:create], module: :surveys
      end
    end
  end
end
