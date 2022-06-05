Rails.application.routes.draw do
  root 'tweets#new'
  resources :tweets, only: %i[new] do
    collection do
      get 'post'
    end
  end
end
