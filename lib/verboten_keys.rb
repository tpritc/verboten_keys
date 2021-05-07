# frozen_string_literal: true

require 'rack'

require_relative 'verboten_keys/version'
require_relative 'verboten_keys/errors'
require_relative 'verboten_keys/configuration'
require_relative 'verboten_keys/filterer'
require_relative 'verboten_keys/middleware'
require_relative 'verboten_keys/railtie' if defined?(::Rails)

module VerbotenKeys
  class << self
    attr_accessor :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end
  end
end
