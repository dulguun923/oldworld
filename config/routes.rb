Rails.application.routes.draw do
  post "/register", to: "users#register"
  post "/login", to: "users#login"
  get  "/me", to: "users#me"
  patch "/me", to: "users#update"
  resources :users, only: [:show]
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:index, :create]
    resource :share, only: [:create, :destroy]
  end
end
