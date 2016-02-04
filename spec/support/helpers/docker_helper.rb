require 'docker'
require 'uri'
require 'uri'
require 'rspec'
require 'rspec/expectations'

class Docker::Container
  def mapped_port(port)
    port_string = port.first.reverse.join '/'
    json['NetworkSettings']['Ports'][port_string].first['HostPort']
  end

  def host
    json['NetworkSettings']['IPAddress']
  end

  def setup_capybara_url(port)
    docker_url = URI.parse Docker.url
    docker_url.host   = 'localhost' if docker_url.scheme == 'unix'
    docker_url.scheme = 'http'
    docker_url.path   = ''
    docker_url.port   = mapped_port port
    Capybara.app_host = docker_url.to_s
  end

  def kill_and_wait(options = {})
    options = { timeout: Docker::DSL.timeout }.merge(options)
    kill options
    wait options[:timeout]
  end

  def wait_for_output(regex)
    thread = Thread.new do
      timeout(Docker::DSL.timeout) do
        Thread.handle_interrupt(TimeoutError => :on_blocking) do
          self.streaming_logs stdout: true, stderr: true, tail: 'all', follow: true do |_, chunk|
            Thread.exit if chunk =~ regex
          end
        end
      end
    end
    thread.join
  end
end
