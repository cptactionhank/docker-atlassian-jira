require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class VolumesMatcher < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(path)
        @expected = path
      end

      def matches?(actual)
        @actual = actual.json['Config']['Volumes']
        @actual.key? @expected
      end

      def description
        "have volume \"#{@expected}\""
      end

      def failure_message
        "expected to have volume \"#{@expected}\" defined"
      end

      def failure_message_when_negated
        "expected not to have volume \"#{@expected}\" defined"
      end
    end

    def have_volume(path)
      VolumesMatcher.new path
    end
  end
end
