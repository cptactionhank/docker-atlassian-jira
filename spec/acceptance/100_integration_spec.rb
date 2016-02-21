require 'timeout'
require 'spec_helper'

describe 'Atlassian JIRA with Embedded Database' do
  include_examples 'an acceptable JIRA instance', 'using an embedded database'
end

describe 'Atlassian JIRA with PostgreSQL 9.3 Database' do
  include_examples 'an acceptable JIRA instance', 'using a postgresql database' do
    before :all do
      Docker::Image.create fromImage: 'postgres:9.3'
      # Create and run a PostgreSQL 9.3 container instance
      @container_db = Docker::Container.create image: 'postgres:9.3'
      @container_db.start!
      # Wait for the PostgreSQL instance to start
      @container_db.wait_for_output %r{PostgreSQL\ init\ process\ complete;\ ready\ for\ start\ up\.}
      # Create Confluence database
      if ENV['CIRCLECI']
        %x( docker run --link "#{@container_db.id}:db" postgres:9.3 psql --host "db" --user "postgres" --command "create database jiradb owner postgres encoding 'utf8';" )
      else
        @container_db.exec ["psql", "--username", "postgres", "--command", "create database jiradb owner postgres encoding 'utf8';"]
      end
    end
    after :all do
      @container_db.remove force: true, v: true unless @container_db.nil? || ENV['CIRCLECI']
    end
  end
end

describe 'Atlassian JIRA with MySQL 5.6 Database' do
  include_examples 'an acceptable JIRA instance', 'using a mysql database' do
    before :all do
      Docker::Image.create fromImage: 'mysql:5.6'
      # Create and run a MySQL 5.6 container instance
      @container_db = Docker::Container.create image: 'mysql:5.6', env: ['MYSQL_ROOT_PASSWORD=mysecretpassword']
      @container_db.start!
      # Wait for the MySQL instance to start
      @container_db.wait_for_output %r{socket:\ '/var/run/mysqld/mysqld\.sock'\ \ port:\ 3306\ \ MySQL\ Community\ Server\ \(GPL\)}
      # Create Confluence database
      if ENV['CIRCLECI']
        %x( docker run --link "#{@container_db.id}:db" mysql:5.6 mysql --host "db" --user=root --password=mysecretpassword --execute 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;' )
      else
        @container_db.exec ['mysql', '--user=root', '--password=mysecretpassword', '--execute', 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;']
      end
    end
    after :all do
      @container_db.remove force: true, v: true unless @container_db.nil? || ENV['CIRCLECI']
    end
  end
end
