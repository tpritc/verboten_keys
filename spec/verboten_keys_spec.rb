# frozen_string_literal: true

RSpec.describe VerbotenKeys do
  describe 'constants' do
    describe 'VERSION' do
      it 'exists' do
        expect { VerbotenKeys::VERSION }.not_to raise_error
      end

      it 'is not nil' do
        expect(VerbotenKeys::VERSION).not_to be nil
      end
    end
  end

  describe 'attributes' do
    describe 'configuration' do
      it 'exists' do
        expect(VerbotenKeys).to respond_to :configuration
      end

      it 'is a VerbotenKeys::Configuration' do
        expect(VerbotenKeys.configuration).to be_a VerbotenKeys::Configuration
      end
    end
  end

  describe 'methods' do
    describe '#configure' do
      it 'yields the configuration' do
        VerbotenKeys.configure do |config|
          expect(config).to eq VerbotenKeys.configuration
        end
      end

      it 'can update the configuration' do
        VerbotenKeys.configure do |config|
          config.forbidden_keys = %i[password secret_token]
          config.strategy = :nullify
        end

        expect(VerbotenKeys.configuration.forbidden_keys).to eq %i[password secret_token]
        expect(VerbotenKeys.configuration.strategy).to eq :nullify
      end
    end

    describe '#reset' do
      before do
        VerbotenKeys.configuration.forbidden_keys = [:password]
        VerbotenKeys.configuration.strategy = :nullify
        VerbotenKeys.reset
      end

      it 'resets the configuration to default values' do
        expect(VerbotenKeys.configuration.forbidden_keys).to eq []
        expect(VerbotenKeys.configuration.strategy).to eq :remove
      end
    end
  end
end
