Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create, :show]
  resources :clearance_queues
  root 'clearance_queues#new'
  get '/itemsbybatch', to: 'items#index_batches'
  post 'scanned', to: 'clearance_queues#processscanned'
  resources :items, only: [:index]
  resources :styles, only: [:index]
end
