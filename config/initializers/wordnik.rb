Wordnik.configure do |config|
  config.api_key = ENV["WORDNIK_API_KEY"]
  config.username = ENV["WORDNIK_USERNAME"]
  config.password = ENV["WORDNIK_PASSWORD"]
  config.response_format = 'json'             # defaults to json, but xml is also supported
  # config.logger = Logger.new('/dev/null')     # defaults to Rails.logger or Logger.new(STDOUT). Set to Logger.new('/dev/null') to disable logging.
end
