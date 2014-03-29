Rails.application.routes.draw do
  resources :word_sets

  resources :words

  root to: "pages#home"
end
