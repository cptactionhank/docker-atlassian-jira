shared_examples 'using a PostgreSQL database' do
  before :all do
    within 'form#jira-setupwizard' do
      # select using external database
      choose 'jira-setupwizard-database-external'
      # allow some time for the DOM to change
      sleep 1
      # fill in database configuration
      fill_in 'databaseType-field', with: 'PostgreSQL'
      fill_in 'jdbcHostname', with: @container_db.host
      fill_in 'jdbcPort', with: '5432'
      fill_in 'jdbcDatabase', with: 'jiradb'
      fill_in 'jdbcUsername', with: 'postgres'
      fill_in 'jdbcPassword', with: 'mysecretpassword'
      # continue database setup
      click_button 'Next'
    end
  end
end
