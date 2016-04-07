require 'docker'
require 'timeout'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class WaitConsoleMatcher < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(expected, options = {})
        @expected = expected
        @options = { timeout: Docker::DSL.timeout }.merge(options)
      end

      def matches?(actual)
        @value = actual.wait_for_output @expected
      end

      def description
        "wait for match #{@expected.inspect} in console output #{@value}"
      end
    end

    def wait_until_output_matches(regex, options = {})
      WaitConsoleMatcher.new regex, options
    end
  end
end
