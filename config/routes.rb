Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'
  post '/search', to: 'home#search'
  get '/check', to: 'home#check'
  get '/load_more', to: 'home#load_more'
  get '/hotel/:id', to: 'home#hotel', as: :hotel
  get '/hotel/:id/check_tours', to: 'home#check_tours', as: :check_tours
end
