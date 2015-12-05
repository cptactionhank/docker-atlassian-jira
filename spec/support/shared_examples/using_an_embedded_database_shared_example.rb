require 'timeout'
require 'spec_helper'

shared_examples 'using an embedded database' do
	before :all do
    within 'form#jira-setup-database' do
      choose 'jira-setup-database-field-database-internal'
      click_button 'Next'
    end
  end

	it { expect(current_path).to match '/secure/SetupApplicationProperties!default.jspa' }
  it { is_expected.to have_css 'form#jira-setupwizard' }
  it { is_expected.to have_field 'title' }
  it { is_expected.to have_selector :radio_button, 'jira-setupwizard-mode-public' }
  it { is_expected.to have_button 'Next' }
end
