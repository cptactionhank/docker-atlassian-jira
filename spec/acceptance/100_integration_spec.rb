# describe 'Atlassian JIRA with Embedded Database' do
#   include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms2048m -Xmx2048m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true"]
# 
#   include_examples 'an acceptable JIRA instance', 'using an embedded database'
# end

# describe 'Atlassian JIRA with PostgreSQL 9.3 Database' do
#   include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx1024m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true"]
#
#   include_examples 'an acceptable JIRA instance', 'using a PostgreSQL database' do
#     before :all do
#       Docker::Image.create fromImage: 'postgres:9.3'
#       # Create and run a PostgreSQL 9.3 container instance
#       @container_db = Docker::Container.create image: 'postgres:9.3'
#       @container_db.start!
#       # Wait for the PostgreSQL instance to start
#       @container_db.wait_for_output(/PostgreSQL\ init\ process\ complete;\ ready\ for\ start\ up\./)
#       # Create JIRA database
#       if ENV['CIRCLECI']
#         `docker run --link "#{@container_db.id}:db" postgres:9.3 psql --host "db" --user "postgres" --command "create database jiradb owner postgres encoding 'utf8';"`
#       else
#         @container_db.exec ['psql', '--username', 'postgres', '--command', "create database jiradb owner postgres encoding 'utf8';"]
#       end
#     end
#     after :all do
#       if ENV['CIRCLECI']
#         @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
#       else
#         @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
#         @container_db.remove force: true, v: true unless @container_db.nil?
#       end
#     end
#   end
# end

# describe 'Atlassian JIRA with MySQL 5.6 Database' do
#   include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx1024m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true"]
#
#   include_examples 'an acceptable JIRA instance', 'using a MySQL database' do
#     before :all do
#       Docker::Image.create fromImage: 'mysql:5.6'
#       # Create and run a MySQL 5.6 container instance
#       @container_db = Docker::Container.create image: 'mysql:5.6', env: ['MYSQL_ROOT_PASSWORD=mysecretpassword']
#       @container_db.start!
#       # Wait for the MySQL instance to start
#       @container_db.wait_for_output %r{socket:\ '/var/run/mysqld/mysqld\.sock'\ \ port:\ 3306\ \ MySQL\ Community\ Server\ \(GPL\)}
#       # Create JIRA database
#       if ENV['CIRCLECI']
#         `docker run --link "#{@container_db.id}:db" mysql:5.6 mysql --host "db" --user=root --password=mysecretpassword --execute 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;'`
#       else
#         @container_db.exec ['mysql', '--user=root', '--password=mysecretpassword', '--execute', 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;']
#       end
#     end
#     after :all do
#       if ENV['CIRCLECI']
#         @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
#       else
#         @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
#         @container_db.remove force: true, v: true unless @container_db.nil?
#       end
#     end
#   end
# end

# describe 'Atlassian JIRA behind reverse proxy' do
#   include_examples 'a buildable Docker image', '.',
#     env: [
#       "CATALINA_OPTS=-Xms1024m -Xmx1024m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true",
#       "X_PROXY_NAME=localhost",
#       'X_PROXY_PORT=1234',
#       'X_PROXY_SCHEME=http',
#       'X_PATH=/jira-path'
#     ]
#
#   include_examples 'an acceptable JIRA instance', 'using an embedded database' do
#     before :all do
#       image = Docker::Image.build_from_dir '.docker/nginx'
#       # Create and run a nginx reverse proxy container instance
#       @container_proxy = Docker::Container.create image: image.id,
#         portBindings: { '80/tcp' => [{ 'HostPort' => '1234' }] },
#         links: ["#{@container.id}:container"]
#       @container_proxy.start!
#       @container_proxy.setup_capybara_url({ tcp: 80 }, '/jira-path/')
#     end
#     after :all do
#       if ENV['CIRCLECI']
#         @container_proxy.kill signal: 'SIGKILL' unless @container_proxy.nil?
#       else
#         @container_proxy.kill signal: 'SIGKILL' unless @container_proxy.nil?
#         @container_proxy.remove force: true, v: true unless @container_proxy.nil?
#       end
#     end
#   end
# end
