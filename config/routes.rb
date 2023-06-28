Rails.application.routes.draw do
  devise_for :users
  root to: "lists#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :lists, only: %i[index show create update destroy]
  resources :list_books, only: %i[create destroy]
  resources :books, only: %i[create]
  get 'books/:googlebooks_id', to: 'books#show', as: 'book'
end
