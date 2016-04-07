shared_examples 'a buildable Docker image' do |path, options = {}|
  before :all do
    image = Docker::Image.build_from_dir(path)
    container_options = { Image: image.id }.merge options
    @container = Docker::Container.create container_options
    @container.start! PublishAllPorts: true
    @container.setup_capybara_url tcp: 8080
    # Apply hack for Travis
    if ENV['TRAVIS']
      Thread.new do
        @container.streaming_logs stdout: true, stderr: true, follow: true do |stream, chunk|
          puts "[#{stream}] #{chunk}"
        end
      end
    end
  end

  describe 'when starting a JIRA Software container' do
    subject { @container }

    it { is_expected.to_not be_nil }
    it { is_expected.to be_running }
    it { is_expected.to have_mapped_ports tcp: 8080 }
    it { is_expected.not_to have_mapped_ports udp: 8080 }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP }
  end

  after :all do
    if ENV['CIRCLECI']
      @container.kill signal: 'SIGKILL' unless @container.nil?
    else
      @container.kill signal: 'SIGKILL' unless @container.nil?
      @container.remove force: true, v: true unless @container.nil?
    end
  end
end
