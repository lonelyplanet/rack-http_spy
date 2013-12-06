require 'forwardable'
require 'webmock'

module Rack
  module HTTPSpy
    class Spy
      include Rack::Utils

      extend Forwardable
      def_delegators :request, :params
      def_delegators :middleware, :app, :store, :reporter, :logger
      def_delegator  :middleware, :format, :default_format
      def_delegator  :middleware, :log_level, :default_log_level

      attr_reader :env, :middleware, :original_response

      def self.spy(*args)
        new(*args).spy
      end

      def initialize(options = {})
        @env = options.fetch(:env)
        @middleware = options.fetch(:middleware)
        store.clear!
      end

      def spy_params
        params['_spy']
      end

      def enabled?
        !!spy_params
      end

      def format
        spy_params['format'] || default_format
      end

      def log_level
        spy_params['log_level'] || default_log_level
      end

      def original_response
        @original_response ||= app.call(env)
      end

      def call_app!
        original_response
      end

      def request
        @request ||= Rack::Request.new(env)
      end

      def report
        @report ||= reporter.report(store: store, format: format, log_level: log_level, request: request)
      end

      def spy
        call_app!
        if enabled?
          log_or_report
        else
          original_response
        end
      end

      private

      def log_or_report
        if logger
          logger.info(report.to_s)
          original_response
        else
          report.to_response
        end
      end
    end
  end
end
