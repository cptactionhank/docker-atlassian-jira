require 'stringio'
require 'docker'
require 'rspec'
require 'rspec/expectations'
require 'archive/tar/minitar'

module Docker
  module DSL
    extend RSpec::Matchers::DSL

    class FileContentMatcher < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize(file, expected, options = {})
        @file = file
        @expected = expected
        @options = options
      end

      def matches?(actual)
        @actual = []
        exception_filter = @options[:filter]
        read_lines_from_files actual do |file, chunk|
          @actual << "[#{file}] #{chunk}" if (chunk =~ @expected) && (chunk !~ exception_filter)
        end
        !@actual.empty?
      end

      def description
        "match #{@expected.inspect} in file content"
      end

      private

      def read_lines_from_files(actual)
        stringio = StringIO.new
        actual.copy(@file) { |chunk| stringio.write chunk }
        stringio.rewind
        input = Archive::Tar::Minitar::Input.new(stringio)
        input.each do |entry|
          (String entry.read).each_line do |chunk|
            yield entry.name, chunk if entry.file?
          end
        end
      end
    end

    def have_file_contain(file, regex, options = {})
      FileContentMatcher.new file, regex, options
    end
  end
end
