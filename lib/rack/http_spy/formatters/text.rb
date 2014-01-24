require 'ansi/code'

module Rack
  module HTTPSpy
    class Report::Text < Report
      def total_label
        " Total: "
      end

      def to_s
        Array.new.tap do |r|
          r << title
          r << ('=' * title.chars.to_a.length)
          list.each do |hsh, req|
            line = "#{req[:sig].method.upcase} #{req[:sig].uri.to_s}: #{req[:count]}"
            line = ANSI::Code.red { line } if req[:count] > 1
            r << line
          end
          lpad = r.max.length - total_label.length - 1
          r << "#{' ' * lpad}#{total_label}#{total}"
          r << ''
        end.join($/)
      end

      def content_type
        "text/plain"
      end
    end
  end
end
