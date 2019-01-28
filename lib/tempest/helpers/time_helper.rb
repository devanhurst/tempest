module Tempest
  module Helpers
    module TimeHelper
      def formatted_time(time)
        time < 60 ? "#{time} minutes" : "#{(time / 60.0)} hours"
      end
    end
  end
end