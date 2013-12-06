require 'digest/sha1'
require 'forwardable'

module Rack
  module HTTPSpy
    class RequestStore
      extend Forwardable

      def_delegators :@reqs, :sort, :sort_by, :each, :map

      def initialize
        clear!
      end

      def store(params)
        req = params[:request]
        key = Digest::SHA1.hexdigest(req.to_s)
        new_count = @reqs[key][:count] + 1
        @reqs[key] = { count: new_count, sig: req }
      end

      def requests
        @reqs
      end

      def clear!
        @reqs = Hash.new { |h, k| h[k] = { count: 0 } }
      end

      def total
        @reqs.reduce(0) { |i, (hsh, req)| i += req[:count] }
      end
    end
  end
end
