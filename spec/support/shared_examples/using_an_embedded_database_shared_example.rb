require 'timeout'
require 'spec_helper'

shared_examples 'using an embedded database' do
  before :all do
    within 'form#jira-setupwizard' do
      choose 'jira-setupwizard-database-internal'
      click_button 'Next'
    end
  end
end
