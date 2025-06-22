# frozen_string_literal: true

RSpec.describe VerbotenKeys::Configuration do
  describe "constants" do
    describe "STRATEGIES" do
      it "equals [:remove, :nullify]" do
        expect(VerbotenKeys::Configuration::STRATEGIES).to eq %i[remove nullify]
      end
    end
  end

  describe "attributes" do
    let(:configuration) { VerbotenKeys::Configuration.new }

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
        it "does not raise an error" do
          expect { configuration.strategy = :nullify }.not_to raise_error
        end

        it "is equal to what it was set as" do
          configuration.strategy = :nullify
          expect(configuration.strategy).to eq :nullify
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
    end
  end
end
