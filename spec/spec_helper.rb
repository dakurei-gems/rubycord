# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "json"

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.filter_run_when_matching focus: true
end

# Keeps track of what events are run; if one isn't run it will fail
class EventTracker
  def initialize(messages)
    @messages = messages
    @tracker = [nil] * @messages.length
  end

  def track(num)
    @tracker[num - 1] = true
  end

  def summary
    @tracker.each_with_index do |tracked, num|
      raise "Not executed: #{@messages[num]}" unless tracked
    end
  end
end

def track(*messages)
  EventTracker.new(messages)
end

RSpec::Matchers.define :something_including do |x|
  match { |actual| actual.include? x }
end

RSpec::Matchers.define :something_not_including do |x|
  match { |actual| !actual.include?(x) }
end

RSpec::Matchers.define_negated_matcher :an_array_excluding, :include

def load_data_file(*name)
  JSON.parse(File.read("#{File.dirname(__FILE__)}/json_examples/#{name.join("/")}.json"))
end

# Creates a helper method that gives access to a particular fixture's data.
# @example Load the JSON file at "spec/data/folder/filename.json" as a "data_name" helper method
#   fixture :data_name, [:folder, :filename]
# @param name [Symbol] The name the helper method should have
# @param path [Array<Symbol>] The path to the data file to load, originating from "spec/data"
def fixture(name, path)
  let name do
    load_data_file(*path)
  end
end

# Creates a helper method that gives access to a specific property on a particular fixture.
# @example Add a helper method called "property_value" for `data_name['properties'][0]['value'].to_i`
#   fixture_property :property_value, :data_name, ['properties', 0, 'value'], :to_i
# @param name [Symbol] The name the helper method should have
# @param fixture [Symbol] The name of the fixture the property is on
# @param trace [Array] The objects to consecutively pass to the #[] method when accessing the data.
# @param filter [Symbol, nil] An optional method to call on the result, in case some conversion is necessary.
def fixture_property(name, fixture, trace, filter = nil)
  let name do
    data = send(fixture)

    trace.each do |e|
      data = data[e]
    end

    if filter
      data.send(filter)
    else
      data
    end
  end
end
