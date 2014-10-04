Rails.application.routes.draw do
  resources :biographies, only: [:index, :show]
end
