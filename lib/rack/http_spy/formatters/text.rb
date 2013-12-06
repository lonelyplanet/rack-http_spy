module Rack
  module HTTPSpy
    class Report::Text < Report
      def total_label
        " Total: "
      end

      def to_s
        Array.new.tap do |r|
          r << title
          r << ('=' * title.chars.size)
          list.each do |hsh, req|
            r << "#{req[:sig].method.upcase} #{req[:sig].uri.to_s}: #{req[:count]}"
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
