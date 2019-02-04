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

        abort('Please provide time in the correct format. e.g. 0.5h, .5h, 30m')
      end

      def formatted_time(seconds)
        if seconds < 3600
          "#{seconds / 60} minutes"
        else
          "#{(seconds / 3600.to_f).round(2)} hours"
        end
      end

      def formatted_date_range(start_date, end_date)
        return formatted_date(start_date) if end_date.nil?
        "#{formatted_date(start_date)} - #{formatted_date(end_date)}"
      end

      def formatted_date(date)
        Date::DAYNAMES[date.wday] +
          ', ' +
          Date::MONTHNAMES[date.month] +
          ' ' +
          date.day.to_s
      end

      def beginning_of_week(weeks_ago = 0)
        return unless weeks_ago >= 0
        (Date.today - Date.today.wday) - (weeks_ago * 7)
      end

      def end_of_week(weeks_ago = 0)
        beginning_of_week(weeks_ago) + 6
      end

      def week_beginnings(number_of_weeks)
        (0..number_of_weeks).map { |weeks_ago| beginning_of_week(weeks_ago) }
      end

      def past_week_selections(number_of_weeks)
        weeks = {}
        week_beginnings(number_of_weeks).each do |beginning|
          weeks[formatted_date_range(beginning, beginning + 6)] = beginning
        end
        weeks
      end

      def past_date_selections(number_of_days)
        dates = {}
        (0..number_of_days).each do |n|
          date = Date.today - n
          dates[formatted_date(date)] = date
        end
        dates
      end

      def week_dates(first_day)
        (0..6).map { |days| first_day + days }
      end
    end
  end
end