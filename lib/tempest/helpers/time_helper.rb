module Tempest
  module Helpers
    module TimeHelper
      def time_in_minutes(time)
        return time if time.is_a?(Integer)

        if /^\d*\.{0,1}\d{1,2}h$/.match(time)
          return (time.chomp('h').to_f * 60).to_i
        elsif /^\d+m$/.match(time)
          return time.chomp('m').to_i
        end
        0
      end

      def formatted_time(time)
        time = time_in_minutes(time)
        time_in_minutes(time) < 60 ? "#{time} minutes" : "#{(time / 60.0)} hours"
      end
    end
  end
end