Rails.application.routes.draw do
  resources :word_sets

  resources :words

  root to: "pages#home"

  get '/index' => redirect('/')

  get '/about/index' => redirect('/about')
  get '/word_sets/index' => redirect('/word_sets')

end
