Rails.application.routes.draw do
  resources :tasks

  post 'drag', to: "drag#update_position"

  resources :tasks do
    patch :update_status, on: :member
  end

  root "tasks#index"
end
