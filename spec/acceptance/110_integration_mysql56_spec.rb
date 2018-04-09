describe 'Atlassian JIRA with MySQL 5.6 Database' do
  include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx1024m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true"]

  include_examples 'an acceptable JIRA instance', 'using a MySQL database' do
    before :all do
      Docker::Image.create fromImage: 'mysql:5.6'
      # Create and run a MySQL 5.6 container instance
      @container_db = Docker::Container.create image: 'mysql:5.6', env: ['MYSQL_ROOT_PASSWORD=mysecretpassword']
      @container_db.start!
      # Wait for the MySQL instance to start
      @container_db.wait_for_output %r{socket:\ '/var/run/mysqld/mysqld\.sock'\ \ port:\ 3306\ \ MySQL\ Community\ Server\ \(GPL\)}
      # Create JIRA database
      if ENV['CIRCLECI']
        `docker run --link "#{@container_db.id}:db" mysql:5.6 mysql --host "db" --user=root --password=mysecretpassword --execute 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;'`
      else
        @container_db.exec ['mysql', '--user=root', '--password=mysecretpassword', '--execute', 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;']
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
