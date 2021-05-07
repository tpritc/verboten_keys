# frozen_string_literal: true

RSpec.describe VerbotenKeys::Middleware do
  let(:response) { get '/test' }

  before do
    VerbotenKeys.configure do |config|
      config.forbidden_keys = [:password]
      config.strategy = :remove
    end
  end

  context 'when the content-type is application/json' do
    let(:body) { { id: 123, name: 'Jane Doe', password: 'foobar123' } }
    let(:body_content_length) { body.to_json.bytesize.to_s }
    let(:endpoint) { JsonTestApp.new(body) }
    let(:app) { VerbotenKeys::Middleware.new(endpoint) }

    context 'when the body does not contain a forbidden key' do
      let(:body) { { id: 123, name: 'Jane Doe', email: 'jane.doe@example.com' } }

      it 'does not alter the status' do
        expect(response.status).to eq 200
      end

      it 'does not alter the headers' do
        expect(response.headers['Content-Type']).to eq 'application/json'
        expect(response.headers['Content-Length']).to eq body_content_length
      end

      it 'does not alter the body' do
        expect(response.body).to eq body.to_json
      end
    end

    context 'when the body contains a forbidden key' do
      let(:body) { { id: 123, name: 'Jane Doe', password: 'foobar123' } }
      let(:expected_body) { { id: 123, name: 'Jane Doe' } }
      let(:expected_body_content_length) { expected_body.to_json.bytesize.to_s }

      it 'does not alter the status' do
        expect(response.status).to eq 200
      end

      it 'does not alter the content type' do
        expect(response.headers['Content-Type']).to eq 'application/json'
      end

      it 'alters the content length' do
        expect(response.headers['Content-Length']).not_to eq body_content_length
        expect(response.headers['Content-Length']).to eq expected_body_content_length
      end

      it 'alters the body' do
        expect(response.body).not_to eq body.to_json
        expect(response.body).to eq expected_body.to_json
      end
    end
  end

  context 'when the content-type is not application/json' do
    let(:body) { '<html><body><h1>Hello, world!</h1><p>Do not strip this password: foobar1234</p></body></html>' }
    let(:body_content_length) { body.bytesize.to_s }
    let(:endpoint) { HtmlTestApp.new(body) }
    let(:app) { VerbotenKeys::Middleware.new(endpoint) }

    it 'does not alter the status' do
      expect(response.status).to eq 200
    end

    it 'does not alter the headers' do
      expect(response.headers['Content-Type']).to eq 'text/html'
      expect(response.headers['Content-Length']).to eq body_content_length
    end

    it 'does not alter the body' do
      expect(response.body).to eq body
    end
  end
end
