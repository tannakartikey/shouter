Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: "dashboard#show"
  end
  root to: "homes#show"
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, only: [:create]
  resources :shouts, only: [:create, :show] do
    member do
      post "like" => "likes#create"
      delete "unlike" => "likes#destroy"
    end
  end

  resources :users, only: [:create, :show] do
    resources :followers, only: [:index]
    member do
      post "follow" => "followed_users#create"
      delete "unfollow" => "followed_users#destroy"
    end
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
