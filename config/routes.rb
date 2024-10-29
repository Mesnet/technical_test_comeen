# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  use_doorkeeper

  resources :desks
  resources :desk_bookings, except: [:create, :update] do
    member do
      post :check_in
      post :check_out
    end
  end
  resources :users, controller: "users/profile"

  namespace :google do
    resources :desks_sheets, except: [:update, :show] do
      member do
        get :sync, to: "list_sync_changes" # GET = list changes that will be made
        post :sync, to: "commit_sync" # POST = apply changes
      end
    end
  end
end
