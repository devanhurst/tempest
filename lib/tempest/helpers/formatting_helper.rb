module Tempest
  module Helpers
    module FormattingHelper
      def braced(text, length)
        padding_amount = length - text.length
        front_padding = ' ' * (padding_amount / 2.0).ceil
        back_padding = ' ' * (padding_amount / 2.0).floor
        '[' + front_padding + text + back_padding + ']'
      end
    end
  end
end