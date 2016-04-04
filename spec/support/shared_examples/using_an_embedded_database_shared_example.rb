shared_examples 'using an embedded database' do
  before :all do
    within 'form#jira-setup-database' do
      choose 'jira-setup-database-field-database-internal'
      click_button 'Next'
    end
  end
end
