require 'rack/test'
require_relative '../lib/rack/http_spy'

RSpec.configure do |config|
  config.order = "random"
  config.include Rack::Test::Methods
  config.after(:each) do
    WebMock::CallbackRegistry.reset
  end
end
