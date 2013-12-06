require_relative 'report'
require_relative 'formatters/text'
require_relative 'formatters/json'
require_relative 'formatters/html'

module Rack
  module HTTPSpy
    class Reporter
      attr_reader :options

      def self.formats
        {
          text: Report::Text,
          json: Report::JSON,
          html: Report::HTML
        }
      end

      def self.report(*args)
        new(*args).report
      end

      def initialize(options = {})
        @options = options
      end

      def report
        formatter.new(options)
      end

      def formatter
        self.class.formats[:options] || Report::Text
      end
    end
  end
end
