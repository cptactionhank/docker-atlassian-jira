module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class << self
      attr_accessor :timeout

      def configure
        yield self
      end
    end

    Docker::DSL.configure do |config|
      config.timeout = nil
    end
  end
end
