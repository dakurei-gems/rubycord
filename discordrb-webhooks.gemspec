load "lib/discordrb/webhooks/version.rb"

Gem::Specification.new do |spec|
  spec.name = "discordrb-webhooks"
  spec.version = Discordrb::Webhooks::VERSION
  spec.authors = ["meew0", "swarley", "Dakurei"]
  spec.email = ["maxime.palanchini@gmail.com"]

  spec.summary = "Webhook client for discordrb"
  spec.description = "A client for Discord's webhooks to fit alongside [discordrb](https://github.com/dakurei-gems/discordrb)."
  spec.homepage = "https://github.com/dakurei-gems/discordrb"
  spec.required_ruby_version = ">= 3.1.3"
  spec.license = "MIT"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/dakurei-gems/discordrb/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = ["lib/discordrb/webhooks.rb"] + IO.popen(%w[git ls-files -z lib/discordrb/webhooks/], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", ">= 2.0.0"
end
