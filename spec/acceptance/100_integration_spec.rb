require 'timeout'
require 'spec_helper'

describe 'Atlassian JIRA with Embedded Database' do
  include_examples 'an acceptable JIRA instance', 'using an embedded database'
end

describe 'Atlassian JIRA with PostgreSQL 9.3 Database' do
  include_examples 'an acceptable JIRA instance', 'using a postgresql database' do
    unless ENV["CI"] == "true"
      before :all do
        # Create and run a PostgreSQL 9.3 container instance
        $container_postgres = Docker::Image.create('fromImage' => 'postgres', 'tag' => '9.3').run
        # Wait for the PostgreSQL instance to start
        $container_postgres.wait_for_output %r{PostgreSQL\ init\ process\ complete;\ ready\ for\ start\ up\.}
        # Create Confluence database
        $container_postgres.exec ["psql", "--username", "postgres", "--command", "create database jiradb owner postgres encoding 'utf8';"]
      end
    else
      before :all do
        $container_postgres = Docker::Container.get 'postgres'
      end
    end

    after :all do
      $container_postgres.remove force: true, v: true unless $container_postgres.nil?
    end
  end
end

describe 'Atlassian JIRA with MySQL 5.6 Database' do
  include_examples 'an acceptable JIRA instance', 'using a mysql database' do
    unless ENV["CI"] == "true"
      before :all do
        # Create and run a MySQL 5.6 container instance
        image = Docker::Image.create('fromImage' => 'mysql', 'tag' => '5.6')
        $container_mysql = Docker::Container.create 'Image' => image.id, 'Env' => ["MYSQL_ROOT_PASSWORD=mysecretpassword"]
        $container_mysql.start!
        # Wait for the MySQL instance to start
        $container_mysql.wait_for_output %r{socket:\ '/var/run/mysqld/mysqld\.sock'\ \ port:\ 3306\ \ MySQL\ Community\ Server\ \(GPL\)}
        # Create Confluence database
        $container_mysql.exec ['mysql', '--user=root', '--password=mysecretpassword', '--execute', 'CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;']
      end
    else
      $container_mysql = Docker::Container.get 'mysql'
    end

    after :all do
      $container_mysql.remove force: true, v: true unless $container_mysql.nil?
    end
  end
end
