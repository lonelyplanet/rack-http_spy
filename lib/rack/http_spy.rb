require 'rack'
require "rack/http_spy/version"
require "rack/http_spy/middleware"

module Rack
  module HTTPSpy
    extend self

    def new(*args)
      Middleware.new(*args)
    end
  end
end
