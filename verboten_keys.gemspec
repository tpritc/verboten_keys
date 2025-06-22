# frozen_string_literal: true

require_relative "lib/verboten_keys/version"

Gem::Specification.new do |spec|
  spec.name          = "verboten_keys"
  spec.version       = VerbotenKeys::VERSION
  spec.authors       = ["Tom Pritchard"]
  spec.email         = ["tom@tpritc.com"]

  spec.summary       = "Verboten Keys is a last line of defense to help prevent you and your team from accidentally leaking private information via your APIs."
  spec.homepage      = "https://github.com/tpritc/verboten_keys"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.0")

  spec.metadata["source_code_uri"] = "https://github.com/tpritc/verboten_keys"
  spec.metadata["changelog_uri"] = "https://github.com/tpritc/verboten_keys/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack", ">= 1.0", "< 4"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "railties", ">= 4.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
  spec.metadata["rubygems_mfa_required"] = "true"
end
