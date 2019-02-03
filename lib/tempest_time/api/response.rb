module TempestTime
  module API
    class Response
      def initialize(raw_response, request)
        @raw_response = raw_response
        @request = request
      end

      def success?
        raw_response.success?
      end

      def failure?
        !success?
      end

      def message
        raw_response.success? ? success_message : failure_message
      end

      private

      attr_reader :raw_response, :request

      def success_message
        'Success!'
      end

      def failure_message
        'Failed!'
      end
    end
  end
end