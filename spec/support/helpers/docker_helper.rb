require 'docker'
require 'uri'

class Docker::Container
  def mapped_port(port)
    port_string = port.first.reverse.join '/'
    json['NetworkSettings']['Ports'][port_string].first['HostPort']
  end

  def setup_capybara_url(port)
    docker_url = URI.parse Docker.url
    docker_url.host = 'localhost' if docker_url.scheme == 'unix'
    docker_url.scheme = 'http'
    docker_url.port = mapped_port port
    Capybara.app_host = docker_url.to_s
  end

  def kill_and_wait(options = {})
    options = { timeout: Docker::DSL.timeout }.merge(options)
    kill options
    wait options[:timeout]
  end
end
