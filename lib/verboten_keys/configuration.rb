# frozen_string_literal: true

module VerbotenKeys
  class Configuration
    STRATEGIES = %i[remove nullify raise].freeze

    attr_accessor :strategy, :include_rails_filter_parameters
    attr_writer :forbidden_keys

    def initialize
      @forbidden_keys = []
      @strategy = :remove
      @include_rails_filter_parameters = false
    end

    def forbidden_keys
      keys = @forbidden_keys.dup

      if @include_rails_filter_parameters
        raise VerbotenKeys::Errors::RailsNotAvailableError unless defined?(Rails)

        rails_params = Rails.application.config.filter_parameters.map(&:to_sym)
        keys = (keys + rails_params).uniq
      end

      keys
    end

    def forbidden_keys=(new_forbidden_keys)
      unless new_forbidden_keys.is_a? Array
        raise VerbotenKeys::Errors::ForbiddenKeysMustBeAnArrayError, new_forbidden_keys
      end

      new_forbidden_keys.each do |new_forbidden_key|
        next if new_forbidden_key.is_a? Symbol

        raise VerbotenKeys::Errors::ForbiddenKeysMustOnlyContainSymbolsError.new(new_forbidden_keys, new_forbidden_key)
      end

      @forbidden_keys = new_forbidden_keys
    end

    def strategy=(new_strategy)
      raise VerbotenKeys::Errors::StrategyMustBeASymbolError, new_strategy unless new_strategy.is_a? Symbol

      raise VerbotenKeys::Errors::StrategyNotFoundError, new_strategy unless STRATEGIES.include? new_strategy

      @strategy = new_strategy
    end
  end
end
