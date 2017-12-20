require 'docker'
require 'rspec'
require 'rspec/expectations'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class WorkingDirectory < RSpec::Matchers::BuiltIn::Eq
      alias parent_matches? matches?

      def matches?(actual)
        parent_matches? actual.json['Config']['WorkingDir']
      end

      def description
        "define working directory \"#{@expected}\""
      end
    end

    def have_working_directory(path)
      WorkingDirectory.new path
    end
  end
end
