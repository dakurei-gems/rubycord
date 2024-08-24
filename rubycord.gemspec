load "lib/rubycord/version.rb"

Gem::Specification.new do |spec|
  spec.name = "rubycord"
  spec.version = Rubycord::VERSION
  spec.authors = ["Dakurei"]
  spec.email = ["maxime.palanchini@gmail.com"]

  spec.summary = "Discord API for Ruby"
  spec.description = "A Ruby implementation of the Discord (https://discord.com) API."
  spec.homepage = "https://github.com/dakurei-gems/rubycord"
  spec.required_ruby_version = ">= 3.1.3"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/dakurei-gems/rubycord/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ examples/ .git .github appveyor Gemfile Rakefile rubycord-webhooks.gemspec README.md LICENSE.txt CHANGELOG.md .yardopts .rspec .markdownlint.json lefthook.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64", ">= 0.2.0"
  spec.add_dependency "bigdecimal", ">= 3.1.8"
  spec.add_dependency "ffi", ">= 1.9.24"
  spec.add_dependency "opus-ruby", ">= 1.0.1"
  spec.add_dependency "faraday", ">= 2.10.1"
  spec.add_dependency "faraday-multipart", ">= 1.0.4"
  spec.add_dependency "websocket-client-simple", ">= 0.3.0"

  spec.add_dependency "rubycord-webhooks", "~> 1.0.0"
end
