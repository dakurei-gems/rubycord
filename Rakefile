require "bundler/gem_helper"

namespace :main do
  Bundler::GemHelper.install_tasks(name: "rubycord")
end

namespace :webhooks do
  Bundler::GemHelper.install_tasks(name: "rubycord-webhooks")
end

task build: %i[main:build webhooks:build]
task release: %i[main:release webhooks:release]

# Make "build" the default task
task default: :build
