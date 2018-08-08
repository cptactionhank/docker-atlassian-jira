require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class StateMatcher < RSpec::Matchers::BuiltIn::Include
      def matches?(actual)
        perform_match(actual.json['State']) { |v| v }
      end

      def description
        improve_hash_formatting "include state#{readable_list_of(expecteds)}"
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
