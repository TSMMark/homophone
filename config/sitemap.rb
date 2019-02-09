# https://github.com/viseztrance/rails-sitemap

Sitemap.configure do |config|
  # config.params_format = "html"
  config.search_change_frequency = "daily"
  config.save_path = "public"
end

Sitemap::Generator.instance.load :host => ENV['HOST_DOMAIN'] do

  # Sample path:
  #   path :faq
  # The specified path must exist in your routes file (usually specified through :as).

  # Sample path with params:
  #   path :faq, :params => { :format => "html", :filter => "recent" }
  # Depending on the route, the resolved url could be http://mywebsite.com/frequent-questions.html?filter=recent.

  # Sample resource:
  #   resources :articles

  # Sample resource with custom objects:
  #   resources :articles, :objects => proc { Article.published }

  # Sample resource with search options:
  #   resources :articles, :priority => 0.8, :change_frequency => "monthly"

  # Sample resource with block options:
  #   resources :activities,
  #             :skip_index => true,
  #             :updated_at => proc { |activity| activity.published_at.strftime("%Y-%m-%d") }
  #             :params => { :subdomain => proc { |activity| activity.location } }

  # Hard code a URL:
  # literal "/my_blog"

  # root to: 'pages#home'
  path :root, :priority => 1

  # get '/browse', to: 'pages#browse', as: 'browse'
  path :browse, :priority => 0.9

  # get '/search' => 'word_sets#index', as: 'word_sets'
  path :word_sets, :priority => 0.8

  # get '/random', to: 'word_sets#pick_random', as: :random_homophone
  path :random_homophone, :priority => 0.7

  # get '/about' => 'pages#about'
  path :about, :priority => 0.6

  # resources :word_sets, :skip_index => true
  WordSet.order("id DESC").find_each do |word_set|
    literal word_set_slug_path(word_set.to_slug) if word_set.to_slug.present?
  end

  # Search by letter.
  ("a".."z").each do |letter|
    literal "/search?type=begin&q=#{letter}", :change_frequency => "weekly"
    literal "/search?type=include&q=#{letter}", :change_frequency => "weekly"
  end

end
