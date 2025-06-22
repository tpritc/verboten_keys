# frozen_string_literal: true

module VerbotenKeys
  class Railtie < ::Rails::Railtie
    initializer "verboten_keys.middleware" do |app|
      app.middleware.use VerbotenKeys::Middleware
    end
  end
end
