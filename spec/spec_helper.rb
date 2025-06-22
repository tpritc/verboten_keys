# frozen_string_literal: true

require "verboten_keys"
require "rack/test"
require "active_support/all"

require "fixtures/html_test_app"
require "fixtures/json_test_app"

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
