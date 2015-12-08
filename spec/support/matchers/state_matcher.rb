require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class StateMatcher < RSpec::Matchers::BuiltIn::Include
      alias_method :parent_matches?, :matches?

      def initialize(*expected)
        @expected = expected
      end

      def matches?(actual)
        parent_matches?(actual.json['State'])
      end

      def description
        described_items = surface_descriptions_in(expected)
        improve_hash_formatting "include state#{described_items}"
      end

      def failure_message
        "expected container state to #{description}"
      end

      def failure_message_when_negated
        "expected container state not to #{description}"
      end
    end

    def include_state(*expected)
      StateMatcher.new(*expected)
    end

    def be_running
      StateMatcher.new 'Running' => true
    end

    def be_stopped
      StateMatcher.new 'Running' => false
    end
  end
end
