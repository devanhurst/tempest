module Tempest
  module Helpers
    module TimeHelper
      def parsed_time(time)
        # Returns seconds.
        return time if time.is_a?(Integer)

        if /^\d*\.{0,1}\d{1,2}h$/.match(time)
          return (time.chomp('h').to_f * 60 * 60).to_i
        elsif /^\d+m$/.match(time)
          return time.chomp('m').to_i * 60
        end

        abort("Please provide time in the correct format. e.g. 0.5h, .5h, 30m")
      end

      def formatted_time(seconds)
        seconds < 3600 ? "#{seconds / 60} minutes" : "#{(seconds / 3600)} hours"
      end
    end
  end
end