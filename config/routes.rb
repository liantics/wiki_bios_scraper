Rails.application.routes.draw do
  resources :biographies, only: [:index, :show]
  resources :people, only: [:index, :show]
  resources :genders, only: [:index]
end
