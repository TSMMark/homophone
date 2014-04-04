Rails.application.routes.draw do
  resources :word_sets

  resources :words

  root to: 'pages#home'

  get '/browse', to: 'pages#browse', controller: 'pages', action: 'browse', as: 'browse'

  get '/browse/index' => redirect('/browse')

  get '/random', to: 'word_sets#random', as: :random_homophone

  get '/index' => redirect('/')
  get '/home' => redirect('/')
  get '/home/index' => redirect('/')

  get '/about/index' => redirect('/about')
  get '/word_sets/index' => redirect('/word_sets')

end
