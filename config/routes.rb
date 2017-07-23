Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  scope format: true, constraints: { format: :json } do
    get :latest, to: 'home#latest'
    get :range, to: 'home#range'
  end
end
