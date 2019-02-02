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
        seconds < 3600 ? "#{seconds / 60} minutes" : "#{(seconds / 3600.to_f).round(2)} hours"
      end

      def formatted_date_range(start_date, end_date)
        return formatted_date(start_date) if end_date.nil? || end_date.empty?
        "#{formatted_date(start_date)} - #{formatted_date(end_date)}"
      end

      def formatted_date(date)
        "#{Date::DAYNAMES[date.wday]}, #{Date::MONTHNAMES[date.month]} #{date.day}"
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

      def beginning_of_this_week
        Date.today - Date.today.wday
      end

      def beginning_of_week(week_number)
        this_week_number = (Date.today + 1).cweek # Add one so weeks begin on Sunday.
        return false unless week_number <= this_week_number
        days_in_the_past = (this_week_number - week_number) * 7
        beginning_of_this_week - days_in_the_past
      end

      def this_week
        (0..6).map do |n|
          beginning_of_this_week + n
        end
      end
    end
  end
end