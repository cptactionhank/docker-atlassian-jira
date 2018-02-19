require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class MapPort < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(expected)
        @expected = (expected.first.reverse.join '/')
      end

      def matches?(actual)
        @actual = actual.json['NetworkSettings']['Ports'].select { |_, v| !v.nil? }
        @actual.key? @expected
      end

      def failure_message
        "expected container to map #{description}"
      end

      def failure_message_when_negated
        "expected container not to map #{description}"
      end
    end

    def have_mapped_ports(port)
      MapPort.new port
    end
  end
end
