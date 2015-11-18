Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create, :show]
  resources :clearance_queues do
    collection { post :process }
  end
  resources :clearance_queues
  root to: "clearance_queues#new"
  get '/itemsbybatch', to: 'items#index_batches'
  resources :items, only: [:index]
  resources :styles, only: [:index]
end
