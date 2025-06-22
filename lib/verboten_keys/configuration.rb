# frozen_string_literal: true

module VerbotenKeys
  class Configuration
    STRATEGIES = %i[remove nullify raise].freeze

    attr_accessor :forbidden_keys, :strategy

    def initialize
      @forbidden_keys = []
      @strategy = :remove
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
