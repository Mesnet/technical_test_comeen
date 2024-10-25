# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  use_doorkeeper

  devise_for :users,
    path: "",
    path_names: {
      registration: "signup",
    },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
    }
end
