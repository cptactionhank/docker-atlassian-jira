require 'timeout'
require 'spec_helper'

shared_examples 'using a postgresql database' do
	before :all do
    within 'form#jira-setup-database' do
    	# select using external database
    	choose 'jira-setup-database-field-database-external'
			wait_for_page
			# fill in database configuration
    	# select "PostgreSQL", :from => 'databaseType'
    	fill_in 'jira-setup-database-field-database-type-field', with: 'PostgreSQL'
    	fill_in 'jdbcHostname', with: $container_postgres.host
    	fill_in 'jdbcPort', with: '5432'
    	fill_in 'jdbcDatabase', with: 'jiradb'
    	fill_in 'jdbcUsername', with: 'postgres'
    	fill_in 'jdbcPassword', with: 'mysecretpassword'
    	# continue database setup
      click_button 'Next'
      wait_for_page
    end
  end

	it { expect(current_path).to match '/secure/SetupApplicationProperties!default.jspa' }
  it { is_expected.to have_css 'form#jira-setupwizard' }
  it { is_expected.to have_field 'title' }
  it { is_expected.to have_selector :radio_button, 'jira-setupwizard-mode-public' }
  it { is_expected.to have_button 'Next' }
end
