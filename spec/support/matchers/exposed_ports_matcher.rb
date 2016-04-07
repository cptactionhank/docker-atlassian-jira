require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL
    include RSpec::Matchers

    class ExposePort < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(expected)
        @expected = expected.first.reverse.join '/'
      end

      def matches?(actual)
        @actual = actual.json['Config']['ExposedPorts']
        @actual.key? @expected
      end

      def failure_message
        "expected image to expose #{description}"
      end

      def failure_message_when_negated
        "expected image not to expose #{description}"
      end
    end

    def have_exposed_port(ports)
      ExposePort.new ports
    end
  end
end
