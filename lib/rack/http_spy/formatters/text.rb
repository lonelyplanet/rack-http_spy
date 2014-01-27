require 'ansi/code'

module Rack
  module HTTPSpy
    class Report::Text < Report
      def total_label
        " Total: "
      end

      def header
        @header ||= [title, '=' * title.chars.to_a.length]
      end

      def body
        @body ||= generate_body
      end

      def footer
        @footer ||= begin
                      lpad = [body.max.length - total_label.length - 1, 0].max
                      ["#{' ' * lpad}#{total_label}#{total}", ""]
                    end
      end

      def to_s
        [header, body, footer].flatten.join($/)
      end

      def content_type
        "text/plain"
      end

      private

      def generate_body
        list.each_with_object([]) do |(hsh, req), a|
          line = "#{req[:sig].method.upcase} #{req[:sig].uri.to_s}: #{req[:count]}"
          line = ANSI::Code.red { line } if req[:count] > 1
          a << line
        end
      end
    end
  end
end
