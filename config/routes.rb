Rails.application.routes.draw do
  resources :tasks

  resources :tasks do
    patch :update_status, on: :member
  end

  root "tasks#index"
end
