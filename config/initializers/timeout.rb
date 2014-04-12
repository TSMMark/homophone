# https://devcenter.heroku.com/articles/request-timeout#timeout-behavior
Rack::Timeout.timeout   = 10  # seconds
# Rack::Timeout.overtime  = 10 # seconds over MAX_REQUEST_AGE
