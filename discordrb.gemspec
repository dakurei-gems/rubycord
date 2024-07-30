# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "discordrb/version"

Gem::Specification.new do |spec|
  spec.name = "discordrb"
  spec.version = Discordrb::VERSION
  spec.authors = %w[meew0 swarley Dakurei]
  spec.email = [""]

  spec.summary = "Discord API for Ruby"
  spec.description = "A Ruby implementation of the Discord (https://discord.com) API."
  spec.homepage = "https://github.com/dakurei-gems/discordrb"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples|lib/discordrb/webhooks)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.metadata = {
    "changelog_uri" => "https://github.com/dakurei-gems/discordrb/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", ">= 1.9.24"
  spec.add_dependency "opus-ruby", ">= 1.0.1"
  spec.add_dependency "rest-client", ">= 2.0.0"
  spec.add_dependency "websocket-client-simple", ">= 0.3.0"
  spec.add_dependency "base64", ">= 0.2.0"
  spec.add_dependency "bigdecimal", ">= 3.1.8"

  spec.add_dependency "discordrb-webhooks", "~> 3.5.0"

  spec.required_ruby_version = ">= 3.1"

  spec.add_development_dependency "bundler", ">= 1.10", "< 3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "redcarpet", "~> 3.6.0" # YARD markdown formatting
  spec.add_development_dependency "rspec", "~> 3.13.0"
  spec.add_development_dependency "standard", "~> 1.39.2"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  spec.add_development_dependency "yard", "~> 0.9.9"
end
