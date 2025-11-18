Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "cnab_files#new"
  resources :cnab_files, only: [ :new, :create ]
  resources :stores, only: [ :index ]

  get "configuration", to: "configuration#index", as: :configuration
  post "configuration/reset_database", to: "configuration#reset_database", as: :configuration_reset_database
end
