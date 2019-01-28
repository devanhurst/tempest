module Tempest
  module API
    class Response
      def initialize(raw_response)
        @raw_response = raw_response
      end

      def message
        raw_response.success? ? success_message : failure_message
      end

      private

      attr_reader :raw_response

      def success_message
        'Success!'
      end

      def failure_message
        'Something went wrong... please try again later.'
      end
    end
  end
end