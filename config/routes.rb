Rails.application.routes.draw do
  
  root to: 'pages#home'

  get     'login'  => 'sessions#new',     as: 'login'
  delete  'logout' => 'sessions#destroy', as: 'logout'

  get '/search' => 'word_sets#index', as: 'word_sets'
  get '/search/index' => redirect('/search')

  resources :h, as: 'word_sets', controller: 'word_sets', only: %i(show new create edit update destroy)

  get '/browse', to: 'pages#browse', as: 'browse'

  get '/browse/index' => redirect('/browse')

  get '/random',      to: 'word_sets#pick_random', as: :random_homophone
  get '/random/:id',  to: 'word_sets#random'

  get '/index' => redirect('/')
  get '/home' => redirect('/')
  get '/home/index' => redirect('/')

  get '/about' => 'pages#about'
  get '/about/index' => redirect('/about')
  get '/word_sets/index' => redirect('/word_sets')

  resources :words, only: %i(show)

  resources :users, only: %i(edit update)

  resources :sessions, only: %i(new create destroy)
end
