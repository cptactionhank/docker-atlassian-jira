require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class ConsoleOutputMatcher < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(expected, options = {})
        @expected = expected
        @options = options
      end

      def matches?(actual)
        @actual = []
        exception_filter = @options[:filter]
        actual.streaming_logs stdout: true, stderr: true, tail: 'all' do |_, chunk|
          @actual << chunk if (chunk =~ @expected) && (chunk !~ exception_filter)
        end
        !@actual.empty?
      end

      def description
        "match #{@expected.inspect} in console output"
      end
    end

    def contain_console_output(regex, options = {})
      ConsoleOutputMatcher.new regex, options
    end
  end
end
