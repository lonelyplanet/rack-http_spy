module Rack
  module HTTPSpy
    class Report
      attr_reader :store, :request, :log_level

      def self.log_levels
        [:summary, :compact, :verbose]
      end

      def initialize(options)
        @store   = options.fetch(:store)
        @request = options.fetch(:request)
        @log_level = self.class.log_levels.find(options[:log_level]) || self.class.log_levels.first
      end

      def title
        "#{request.request_method} #{request.path}"
      end

      def total
        store.total
      end

      def list
        store.requests
      end

      def to_response
        [200, { "Content-Type" => content_type  }, Array(self.to_s)]
      end

      def to_s
        raise "not implemented"
      end

      def content_type
        raise "not implemented"
      end
    end
  end
end
