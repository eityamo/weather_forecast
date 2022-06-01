Rails.application.routes.draw do
  root 'tweets#new'
  resources :tweets, only: %i[new create]
end
