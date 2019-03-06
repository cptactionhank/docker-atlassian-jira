#describe 'Atlassian JIRA behind reverse proxy' do
#  include_examples 'a buildable Docker image', '.',
#    env: [
#      "CATALINA_OPTS=-Xms1024m -Xmx1024m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true",
#      "X_PROXY_NAME=localhost",
#      'X_PROXY_PORT=1234',
#      'X_PROXY_SCHEME=http',
#      'X_PATH=/jira-path'
#    ]
#
#  include_examples 'an acceptable JIRA instance', 'using an embedded database' do
#    before :all do
#      image = Docker::Image.build_from_dir '.docker/nginx'
#      # Create and run a nginx reverse proxy container instance
#      @container_proxy = Docker::Container.create image: image.id,
#        portBindings: { '80/tcp' => [{ 'HostPort' => '1234' }] },
#        links: ["#{@container.id}:container"]
#      @container_proxy.start!
#      @container_proxy.setup_capybara_url({ tcp: 80 }, '/jira-path/')
#    end
#    after :all do
#      if ENV['CIRCLECI']
#        @container_proxy.kill signal: 'SIGKILL' unless @container_proxy.nil?
#      else
#        @container_proxy.kill signal: 'SIGKILL' unless @container_proxy.nil?
#        @container_proxy.remove force: true, v: true unless @container_proxy.nil?
#      end
#    end
#  end
#end
