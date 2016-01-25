Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'
  post '/search', to: 'home#search'
  get '/test', to: 'home#test'
end
