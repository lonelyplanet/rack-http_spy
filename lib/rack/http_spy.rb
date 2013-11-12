require 'rack'
require "rack/http_spy/version"
require "rack/http_spy/webmock"
require "rack/http_spy/middleware"

module Rack
  module HTTPSpy
    def self.new(app, options={})
      Middleware.new(app, options)
    end
  end
end
