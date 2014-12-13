Rails.application.routes.draw do
  resources :source_emotions

  resources :source_categories

  resources :categories

  resources :votes

  resources :comments

  resources :sources

  resources :emotions

  resources :users

  root to: 'sources#index'
end
