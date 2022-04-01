Rails.application.routes.draw do
  root to: "games#index"
  
  resources :games, only: [:index, :show, :create, :update] do
    member do
      patch :add_name
    end
  end
    
end
