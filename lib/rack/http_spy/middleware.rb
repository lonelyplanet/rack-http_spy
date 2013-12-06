require "rack/http_spy/request_store"
require "rack/http_spy/reporter"
require "rack/http_spy/spy"

module Rack
  module HTTPSpy
    class Middleware
      attr_reader :options, :app

      def initialize(app, options = {})
        @options = options
        @app     = app
        activate_webmock_hook
      end

      def call(env)
        Spy.spy(env: env, middleware: self)
      end

      def store
        @store ||= options.fetch(:store, RequestStore.new)
      end

      def reporter
        @reporter ||= options.fetch(:reporter, Reporter)
      end

      def logger
        @logger ||= options.fetch(:logger, nil)
      end

      def format
        @format ||= options.fetch(:format, :text)
      end

      def log_level
        @log_level ||= options.fetch(:log_level, :summary)
      end

      private

      def activate_webmock_hook
        # activate WebMock, but allow every request
        WebMock.disable_net_connect!(allow: /.*/)
        WebMock.after_request do |req, _|
          store.store(request: req)
        end
      end
    end
  end
end
