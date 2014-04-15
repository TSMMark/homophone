Rails.application.routes.draw do
  
  root to: 'pages#home'

  get     'login'  => 'sessions#new',     as: 'login'
  delete  'logout' => 'sessions#destroy', as: 'logout'

  resources :word_sets

  get '/browse', to: 'pages#browse', controller: 'pages', action: 'browse', as: 'browse'

  get '/browse/index' => redirect('/browse')

  get '/random',      to: 'word_sets#pick_random', as: :random_homophone
  get '/random/:id',  to: 'word_sets#random'

  get '/index' => redirect('/')
  get '/home' => redirect('/')
  get '/home/index' => redirect('/')

  get '/about/index' => redirect('/about')
  get '/word_sets/index' => redirect('/word_sets')

  resources :words

  resources :users, only: [:edit, :update]

  resources :sessions, only: [:new, :create, :destroy]

end
