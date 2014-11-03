Rails.application.routes.draw do
  resources :biographies, only: [:index, :show]
  resources :biography_statistics, only: [:index, :new]
  resources :names, only: [:index, :show]
  resources :genders, only: [:index, :new]

  root to: 'biography_statistics#index'
end
