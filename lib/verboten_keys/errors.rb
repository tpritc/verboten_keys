# frozen_string_literal: true

module VerbotenKeys
  module Errors
    class ForbiddenKeysMustBeAnArrayError < StandardError
      def initialize(invalid_forbidden_keys)
        invalid_forbidden_keys_string = invalid_forbidden_keys&.to_s || "nil"
        invalid_forbidden_keys_class = invalid_forbidden_keys.class.to_s
        super("VerbotenKeys' forbidden_keys must be an array of symbols. You passed in #{invalid_forbidden_keys_string}, which was a #{invalid_forbidden_keys_class}.")
      end
    end

    class ForbiddenKeysMustOnlyContainSymbolsError < StandardError
      def initialize(invalid_forbidden_keys, invalid_forbidden_key)
        invalid_forbidden_key_string = invalid_forbidden_key&.to_s || "nil"
        invalid_forbidden_key_class = invalid_forbidden_key.class.to_s
        super("VerbotenKeys' forbidden_keys must be an array of symbols. You passed in #{invalid_forbidden_keys}, which included #{invalid_forbidden_key_string}, which was a #{invalid_forbidden_key_class}")
      end
    end

    class StrategyMustBeASymbolError < StandardError
      def initialize(invalid_strategy)
        invalid_strategy_string = invalid_strategy&.to_s || "nil"
        invalid_strategy_class = invalid_strategy.class.to_s
        super("VerbotenKeys' strategy must be a symbol. You passed in #{invalid_strategy_string}, which was a #{invalid_strategy_class}.")
      end
    end

    class StrategyNotFoundError < StandardError
      def initialize(invalid_strategy)
        super("VerbotenKeys' strategy must be a valid option. You passed in :#{invalid_strategy}, but the only valid options are: #{VerbotenKeys::Configuration::STRATEGIES}.")
      end
    end

    class RailsNotAvailableError < StandardError
      def initialize
        super("Rails integration is enabled but Rails is not available. Either disable use_rails_filter_parameters or ensure Rails is loaded.")
      end
    end
  end
end
