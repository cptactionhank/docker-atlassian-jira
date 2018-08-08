require 'docker'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'poltergeist/suppressor'

REGEX_WARN    = /WARNING|WARN/
REGEX_ERROR   = /ERROR|ERR/
REGEX_SEVERE  = /SEVERE|FATAL/
REGEX_STARTUP = /Server startup in (\d+ ms)/
REGEX_FILTER  = Regexp.compile Regexp.union [
  /org\.apache\.catalina\.loader\.WebappClassLoaderBase\.checkThreadLocalMapForLeaks\ The\ web\ application\ \[.+\]\ created\ a\ ThreadLocal\ with\ key\ of\ type\ \[.*\]\ \(value\ \[.*\]\)\ and\ a\ value\ of\ type\ \[.*\]\ \(value\ \[.*\]\)\ but\ failed\ to\ remove\ it\ when\ the\ web\ application\ was\ stopped\.\ Threads\ are\ going\ to\ be\ renewed\ over\ time\ to\ try\ and\ avoid\ a\ probable\ memory\ leak\./,
  /\[c\.a\.jira\.upgrade\.ConsistencyCheckImpl\]\ Indexing\ is\ turned\ on,\ but\ index\ path\ \[null\]\ invalid\ \-\ disabling\ indexing/,
  /\[c\.a\.j\.issue\.index\.DefaultIndexManager\]\ File\ path\ not\ set\ \-\ not\ indexing/
]

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Docker::DSL
  config.include WaitingHelper

  # set the default timeout to 10 minutes.
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

  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new app, timeout: timeout,
    # we should't care about javascript errors since we did not make any
    # implementation, but only deliver the software packages as best
    # effort and this is more an Atlassian problem.
    js_errors: false,
    phantomjs_logger: Capybara::Poltergeist::Suppressor.new
  end

  Capybara.configure do |conf|

    # Since we're connecting to a running Docker container, Capybara should
    # not startup a Rails server.
    conf.run_server = false
    conf.default_driver = :poltergeist_debug
    conf.default_max_wait_time = timeout

    # conf.ignore_hidden_elements = false
    # conf.visible_text_only = false
  end

  Docker::DSL.configure do |conf|
    conf.timeout = timeout
  end
end
