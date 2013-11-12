require 'webmock'
require 'digest/sha1'

module Rack
  module HTTPSpy
    class Middleware
      include Rack::Utils

      def initialize(app, options = {})
        @options = options
        @app     = app
        @store   = RequestStore.new
        setup_webmock
      end

      def call(env)
        @env = env
        request = Rack::Request.new(env)
        if request.GET['_spy'] != nil
          @store.clear!
          @app.call(env)
          @store.report
        else
          @app.call(env)
        end
      end

      private

      def setup_webmock
        WebMock.disable_net_connect!(:allow => ["localhost", "127.0.0.1"])
        WebMock.after_request do |req_signature, response|
          @store.store(req_signature, response)
        end
      end

      class RequestStore
        def initialize
          clear!
        end

        def store(req_signature, response)
          h = Digest::SHA1.hexdigest(req_signature.to_s)
          @hash[h] += 1
        end

        private

        def clear!
          @hash = Hash.new { |h, k| h[k] = 0 }
        end
      end
    end
  end
end
