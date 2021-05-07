# frozen_string_literal: true

module VerbotenKeys
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # Get the result of the request from the app.
      @status, @headers, @response = @app.call(env)

      # Perform all of our work here...
      remove_forbidden_keys

      # Let the app continue as-is.
      [@status, @headers, @response]
    end

    private

    def remove_forbidden_keys
      return unless content_type_is_json?

      new_response = VerbotenKeys::Filterer.filter_forbidden_keys(response_body_as_a_hash).to_json

      @headers['Content-Length'] = new_response.bytesize.to_s
      @response = [new_response]
    end

    # Check's the response's headers to see if the response's content-type is a
    # JSON object.
    #
    # @return [Boolean] True if the content type of the response if JSON, and
    #   false if it is not.
    def content_type_is_json?
      return false if @headers['Content-Type'].nil?

      @headers['Content-Type'].split(';').first == 'application/json'
    end

    def response_body_as_a_hash
      if @response.is_a? Array
        JSON.parse(@response.first || '{}')
      else
        JSON.parse(@response.body || '{}')
      end
    end
  end
end
