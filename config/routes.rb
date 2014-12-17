Rails.application.routes.draw do
  mount_roboto
  root to: 'pages#home'

  get     'login'  => 'sessions#new',     as: 'login'
  delete  'logout' => 'sessions#destroy', as: 'logout'

  get '/search' => 'word_sets#index', as: 'word_sets'
  post '/search' => 'word_sets#create'

  get '/search/index' => redirect('/search')

  constraints(id: /\d+/) do
    resources :h, as: 'word_sets', controller: 'word_sets', only: %i(show new edit update destroy)
  end
  get '/h/:slug' => 'word_sets#from_slug'

  get '/browse', to: 'pages#browse', as: 'browse'

  get '/browse/index' => redirect('/browse')

  get '/random',      to: 'word_sets#pick_random', as: :random_homophone
  get '/random/:id',  to: 'word_sets#random'

  get '/index' => redirect('/')
  get '/home' => redirect('/')
  get '/home/index' => redirect('/')

  get '/about' => 'pages#about'
  get '/about/index' => redirect('/about')

  resources :words, only: %i(show)

  resources :users, only: %i(edit update)

  resources :sessions, only: %i(new create destroy)

  get '/:filename' => 'legacy#results', :constraints => { :filename => /results\.php/ }
  get '/:filename' => 'legacy#default', :constraints => { :filename => /.*\.(php|html)/ }
end
