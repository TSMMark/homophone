ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.use_transactional_fixtures = true

  # --seed 1234
  config.order = "random"
end

def assert_response_redirect(response, path)
  expect(response.headers["Location"]).to end_with path
end

# Stub the controller current_ability to spoof admin access.
def admin!
  @ability = Object.new.tap do |ability|
    ability.extend(CanCan::Ability)
    ability.can(:manage, :all)
  end
  allow(@controller).to receive_messages(:current_ability => @ability)
end
