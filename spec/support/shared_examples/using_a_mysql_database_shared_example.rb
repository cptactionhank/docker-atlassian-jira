require 'timeout'
require 'spec_helper'

shared_examples 'using a mysql database' do
	before :all do
    within 'form#jira-setup-database' do
    	# select using external database
    	choose 'jira-setup-database-field-database-external'
			wait_for_page
			# fill in database configuration
    	# select "PostgreSQL", :from => 'databaseType'
    	fill_in 'jira-setup-database-field-database-type-field', with: 'MySQL'
    	fill_in 'jdbcHostname', with: $container_mysql.host
    	fill_in 'jdbcPort', with: '3306'
    	fill_in 'jdbcDatabase', with: 'jiradb'
    	fill_in 'jdbcUsername', with: 'root'
    	fill_in 'jdbcPassword', with: 'mysecretpassword'
    	# continue database setup
      click_button 'Next'
      wait_for_page
    end
  end
end
