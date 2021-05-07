# frozen_string_literal: true

RSpec.describe VerbotenKeys::Filterer do
  describe 'methods' do
    describe '#filter_forbidden_keys' do
      let(:hash) { {} }
      let(:result) { VerbotenKeys::Filterer.filter_forbidden_keys(hash) }

      before do
        VerbotenKeys.reset
        VerbotenKeys.configuration.forbidden_keys = [:password]
      end

      context 'when a forbidden key is in the hash' do
        let(:hash) do
          {
            id: 123,
            name: 'Jane Doe',
            email: 'jane.doe@example.com',
            password: 'foobar1234'
          }
        end

        context 'when the strategy is :remove' do
          before do
            VerbotenKeys.configuration.strategy = :remove
          end

          it 'is removed' do
            expect(result).to eq(
              {
                id: 123,
                name: 'Jane Doe',
                email: 'jane.doe@example.com'
              }
            )
          end
        end

        context 'when the strategy is :nullify' do
          before do
            VerbotenKeys.configuration.strategy = :nullify
          end

          it 'is nullified' do
            expect(result).to eq(
              {
                id: 123,
                name: 'Jane Doe',
                email: 'jane.doe@example.com',
                password: nil
              }
            )
          end
        end

        context 'when the forbidden key is nested in another hash in the hash' do
          let(:hash) do
            {
              id: 123,
              team_name: 'Example Inc.',
              owner: {
                id: 456,
                name: 'Jane Doe',
                email: 'jane.doe@example.com',
                password: 'foobar1234'
              }
            }
          end

          it 'is filtered' do
            expect(result).to eq(
              {
                id: 123,
                team_name: 'Example Inc.',
                owner: {
                  id: 456,
                  name: 'Jane Doe',
                  email: 'jane.doe@example.com'
                }
              }
            )
          end
        end

        context 'when the forbidden key is nested in a hash in an array in the hash' do
          let(:hash) do
            {
              id: 123,
              team_name: 'Example Inc.',
              members: [
                {
                  id: 456,
                  name: 'Jane Doe',
                  email: 'jane.doe@example.com',
                  password: 'foobar1234'
                },
                {
                  id: 789,
                  name: 'John Smith',
                  email: 'john.smith@example.com',
                  password: 'foobiz5678'
                }
              ]
            }
          end

          it 'is filtered' do
            expect(result).to eq(
              {
                id: 123,
                team_name: 'Example Inc.',
                members: [
                  {
                    id: 456,
                    name: 'Jane Doe',
                    email: 'jane.doe@example.com'
                  },
                  {
                    id: 789,
                    name: 'John Smith',
                    email: 'john.smith@example.com'
                  }
                ]
              }
            )
          end
        end
      end

      context 'when a forbidden key is not in the hash' do
        let(:hash) { { id: 123, name: 'Jane Doe' } }

        it 'is the same as the input hash' do
          expect(result).to eq hash
        end
      end
    end
  end
end
