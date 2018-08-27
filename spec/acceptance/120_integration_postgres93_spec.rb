describe 'Atlassian JIRA with PostgreSQL 9.3 Database' do
  include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx1024m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true"]

  include_examples 'an acceptable JIRA instance', 'using a PostgreSQL database' do
    before :all do
      Docker::Image.create fromImage: 'postgres:9.3'
      # Create and run a PostgreSQL 9.3 container instance
      @container_db = Docker::Container.create image: 'postgres:9.3'
      @container_db.start!
      # Wait for the PostgreSQL instance to start
      @container_db.wait_for_output(/PostgreSQL\ init\ process\ complete;\ ready\ for\ start\ up\./)
      # Create JIRA database
      if ENV['CIRCLECI']
        `docker run --link "#{@container_db.id}:db" postgres:9.3 psql --host "db" --user "postgres" --command "create database jiradb owner postgres encoding 'utf8';"`
      else
        @container_db.exec ['psql', '--username', 'postgres', '--command', "create database jiradb owner postgres encoding 'utf8';"]
      end
    end
    after :all do
      if ENV['CIRCLECI']
        @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
      else
        @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
        @container_db.remove force: true, v: true unless @container_db.nil?
      end
    end
  end
end
