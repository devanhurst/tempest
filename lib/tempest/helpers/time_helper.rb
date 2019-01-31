module Tempest
  module Helpers
    module TimeHelper
      DAY_NAMES = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze
      MONTH_NAMES = %w[January February March April May June July August September October November December].freeze

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
        seconds < 3600 ? "#{seconds / 60} minutes" : "#{(seconds / 3600.to_f).round(2)} hours"
      end

      def formatted_date(date)
        "#{DAY_NAMES[date.wday]}, #{MONTH_NAMES[date.month - 1]} #{date.day}"
      end

      def parsed_date_input(date_input)
        case date_input
        when 'today', nil
          [Date.today]
        when 'yesterday'
          [Date.today.prev_day]
        when 'week'
          this_week
        else
          [Date.parse(date_input)]
        end
      end

      def this_week
        sunday = Date.today - Date.today.wday
        (0..6).map do |n|
          sunday + n
        end
      end
    end
  end
end