# frozen_string_literal: true

module VerbotenKeys
  class Filterer
    def self.filter_forbidden_keys(hash)
      hash
        .to_h { |k, v| evaluate_key_value_pair(k, v) }
        .delete_if { |k, _v| k.nil? }
    end

    def self.evaluate_key_value_pair(key, value)
      key = key.to_sym

      if VerbotenKeys.configuration.forbidden_keys.include?(key)
        case VerbotenKeys.configuration.strategy
        when :remove
          return [nil, nil]
        when :nullify
          return [key, nil]
        else
          raise VerbotenKeys::Errors::StrategyNotFoundError(VerbotenKeys.configuration.strategy)
        end
      end

      case value
      when Hash
        return [key, VerbotenKeys::Filterer.filter_forbidden_keys(value)]
      when Array
        return [key, value.map { |item| item.is_a?(Hash) ? VerbotenKeys::Filterer.filter_forbidden_keys(item) : item }]
      end

      [key, value]
    end
  end
end
