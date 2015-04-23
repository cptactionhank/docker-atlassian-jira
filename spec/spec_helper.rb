require 'docker'
require 'capybara'
require 'capybara/poltergeist'
require 'poltergeist/suppressor'

REGEX_SEVERE  = /SEVERE|FATAL/
REGEX_WARN    = /WARNING|WARN/
REGEX_ERROR   = /ERROR|ERR/
REGEX_STARTUP = /Server startup in \d+ ms/
REGEX_FILTER  =
[
  # when `dbconfig.xml` does not exists when starting up instance
  /no\ defaultDS\ datasource/,
  # https://jira.atlassian.com/browse/JRA-42576
  /\[atlassian\.jira\.tenancy\.PluginKeyPredicateLoader\]\ Could\ not\ read\ tenant\-smart\ pattern\ file\ '\/usr\/local\/atlassian\/jira\/atlassian\-jira\/WEB\-INF\/classes\/tenant\-smart\-patterns\.txt'\ \(using\ defaults\)/
].inject { |*args| Regexp.union(*args) }

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Docker::DSL

  timeout = 600

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.

  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true

    # Configure the Rspec to only accept the new syntax on new projects, to
    # avoid having the 2 syntax all over the place.
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  Excon.defaults[:write_timeout] = timeout
  Excon.defaults[:read_timeout]  = timeout

  Capybara.configure do |conf|
    conf.register_driver :poltergeist_debug do |app|
      Capybara::Poltergeist::Driver.new app, timeout: timeout
    end

    conf.run_server = false
    conf.default_driver = :poltergeist_debug
    conf.default_wait_time = timeout
  end

  Docker::DSL.configure do |conf|
    conf.timeout = timeout
  end
end
