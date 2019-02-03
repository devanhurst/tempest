require 'date'

module TempestTime
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
        return formatted_date(start_date) if end_date.nil?
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
        when 'week', 'thisweek'
          week_dates(current_week)
        when 'lastweek'
          week_dates(current_week - 1)
        else
          [Date.parse(date_input)]
        end
      end

      def current_week
        # Helper method to make weeks start on Sunday instead of Monday.
        @current_week ||= (Date.today + 1).cweek
      end

      def beginning_of_week(week_number)
        return unless week_number.positive? && week_number < 53
        (Date.today - Date.today.wday) - ((current_week - week_number) * 7)
      end

      def week_beginnings
        @week_beginnings ||= (1..52).map { |week_number| beginning_of_week(week_number) }
      end

      def week_ranges
        @week_ranges ||= week_beginnings.map do |start_date|
          formatted_date_range(start_date, start_date + 6)
        end
      end

      def week_dates(week_number)
        (0..6).map { |days| beginning_of_week(week_number) + days }
      end
    end
  end
end