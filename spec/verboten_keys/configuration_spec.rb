# frozen_string_literal: true

RSpec.describe VerbotenKeys::Configuration do
  describe "constants" do
    describe "STRATEGIES" do
      it "equals [:remove, :nullify, :raise]" do
        expect(VerbotenKeys::Configuration::STRATEGIES).to eq %i[remove nullify raise]
      end
    end
  end

  describe "attributes" do
    let(:configuration) { VerbotenKeys::Configuration.new }

    describe "use_rails_filter_parameters" do
      it "exists" do
        expect(configuration).to respond_to :use_rails_filter_parameters
      end

      it "defaults to false" do
        expect(configuration.use_rails_filter_parameters).to eq false
      end

      it "can be set to true" do
        configuration.use_rails_filter_parameters = true
        expect(configuration.use_rails_filter_parameters).to eq true
      end
    end

    describe "forbidden_keys" do
      it "exists" do
        expect(configuration).to respond_to :forbidden_keys
      end

      context "when it is not an array" do
        it "raises an error" do
          expect do
            configuration.forbidden_keys = :password
          end.to raise_error(VerbotenKeys::Errors::ForbiddenKeysMustBeAnArrayError)
        end
      end

      context "when it is an array" do
        context "when it contains an object that is not a symbol" do
          it "raises an error" do
            expect do
              configuration.forbidden_keys = ["password"]
            end.to raise_error(VerbotenKeys::Errors::ForbiddenKeysMustOnlyContainSymbolsError)
          end
        end

        context "when it only contains symbols" do
          it "does not raise an error" do
            expect { configuration.forbidden_keys = %i[password password_digest] }.not_to raise_error
          end

          it "is equal to what it was set as" do
            configuration.forbidden_keys = %i[password password_digest]
            expect(configuration.forbidden_keys).to eq %i[password password_digest]
          end
        end
      end

      context "when use_rails_filter_parameters is enabled" do
        before do
          configuration.use_rails_filter_parameters = true
        end

        context "when Rails is not available" do
          before do
            hide_const("Rails") if defined?(Rails)
          end

          it "raises an error" do
            expect { configuration.forbidden_keys }.to raise_error(VerbotenKeys::Errors::RailsNotAvailableError)
          end
        end

        context "when Rails is available" do
          let(:mock_rails) { double("Rails") }
          let(:mock_app) { double("App") }
          let(:mock_config) { double("Config") }

          before do
            stub_const("Rails", mock_rails)
            allow(mock_rails).to receive(:application).and_return(mock_app)
            allow(mock_app).to receive(:config).and_return(mock_config)
            allow(mock_config).to receive(:filter_parameters).and_return(%i[password secret])
          end

          context "when no custom forbidden_keys are set" do
            it "returns Rails filter_parameters" do
              expect(configuration.forbidden_keys).to eq %i[password secret]
            end
          end

          context "when custom forbidden_keys are set" do
            before do
              configuration.forbidden_keys = %i[api_key]
            end

            it "merges custom keys with Rails filter_parameters" do
              expect(configuration.forbidden_keys).to eq %i[api_key password secret]
            end
          end

          context "when there are duplicate keys" do
            before do
              configuration.forbidden_keys = %i[password api_key]
            end

            it "removes duplicates" do
              expect(configuration.forbidden_keys).to eq %i[password api_key secret]
            end
          end
        end
      end
    end

    describe "strategy" do
      it "exists" do
        expect(configuration).to respond_to :strategy
      end

      context "when it is set to a value that is not a symbol" do
        it "raises an error" do
          expect { configuration.strategy = "nullify" }.to raise_error(VerbotenKeys::Errors::StrategyMustBeASymbolError)
        end
      end

      context "when it is set to a value not in the acceptable strategies" do
        it "raises an error" do
          expect do
            configuration.strategy = :invalid_strategy
          end.to raise_error(VerbotenKeys::Errors::StrategyNotFoundError)
        end
      end

      context "when it is set to a value in the acceptable strategies" do
        it "accepts :remove strategy" do
          expect { configuration.strategy = :remove }.not_to raise_error
          configuration.strategy = :remove
          expect(configuration.strategy).to eq :remove
        end

        it "accepts :nullify strategy" do
          expect { configuration.strategy = :nullify }.not_to raise_error
          configuration.strategy = :nullify
          expect(configuration.strategy).to eq :nullify
        end

        it "accepts :raise strategy" do
          expect { configuration.strategy = :raise }.not_to raise_error
          configuration.strategy = :raise
          expect(configuration.strategy).to eq :raise
        end
      end
    end
  end

  describe "methods" do
    describe "initialize" do
      let!(:configuration) { VerbotenKeys::Configuration.new }

      it "sets forbidden_keys to its default value" do
        expect(configuration.forbidden_keys).to eq []
      end

      it "sets strategy to its default value" do
        expect(configuration.strategy).to eq :remove
      end

      it "sets use_rails_filter_parameters to its default value" do
        expect(configuration.use_rails_filter_parameters).to eq false
      end
    end
  end
end
