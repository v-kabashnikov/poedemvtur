Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'
  post '/search', to: 'home#search'
  post '/search_hotel/:hotel_id', to: 'home#search_hotel', as: :search_hotel
  get '/check', to: 'home#check'
  get '/load_more', to: 'home#load_more'
  get '/hotel/:id', to: 'home#hotel', as: :hotel
  get '/hotel/:id/check_tours', to: 'home#check_tours', as: :check_tours
  get '/hotel/:id/load_more_tours', to: 'home#load_more_tours', as: :load_more_tours
end
