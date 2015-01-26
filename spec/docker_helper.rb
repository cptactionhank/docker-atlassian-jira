require 'timeout'
require 'docker'

module DockerHelper

	TIMEOUT = 1200

	def scan_stdout(regex, opts={})
		opts = { container: $container, timeout: TIMEOUT }.merge(opts)

		thread = Thread.new do
			Timeout::timeout(opts[:timeout]) do
				thread["errors"] = []
				Thread.handle_interrupt(TimeoutError => :on_blocking) {
					opts[:container].attach(stream: false, logs: true, stdout: true, stderr: true) do |stream, chunk|
						Thread.current[:errors] << chunk if ( chunk =~ regex )
					end
				}
			end
		end

		thread.join
		
		thread[:errors]
	end

	def wait_stdout(regex, opts={})
		opts = { container: $container, timeout: TIMEOUT }.merge(opts)

		thread = Thread.new do
			Timeout::timeout(opts[:timeout]) do
				Thread.handle_interrupt(TimeoutError => :on_blocking) {
					opts[:container].attach(stream: true, logs: true, stdout: true, stderr: true) do |stream, chunk|
						Thread.exit if chunk =~ regex
					end
				}
			end
		end

		thread.join
	end

end