require 'timeout'
require 'spec_helper'

describe 'Atlassian JIRA instance' do
  include_context 'a buildable docker image', '.', Env: ["CATALINA_OPTS=-Xms64m -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout}"]

  describe 'when starting a JIRA instance' do
    before(:all) { @container.start! PublishAllPorts: true }

    it { is_expected.to_not be_nil }
    it { is_expected.to be_running }
    it { is_expected.to have_mapped_ports tcp: 8080 }
    it { is_expected.not_to have_mapped_ports udp: 8080 }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP }
  end

  describe 'Going through the setup process' do
    before :all do
      @container.setup_capybara_url tcp: 8080
      visit '/'
    end

    subject { page }

    context 'when visiting root page' do
      it { expect(current_path).to match '/secure/SetupMode!default.jspa' }
      it { is_expected.to have_title 'JIRA - JIRA Setup' }
      it { is_expected.to have_css 'form#jira-setup-mode' }
      it { is_expected.to have_css 'div[data-choice-value=classic]' }
    end

    context 'when processing welcome setup' do
      before :all do
        within 'form#jira-setup-mode' do
          find(:css, 'div[data-choice-value=classic]').trigger('click')
          click_button 'Next'
        end
      end

      it { expect(current_path).to match '/secure/SetupDatabase!default.jspa' }
      it { is_expected.to have_title 'JIRA - JIRA Setup' }
      it { is_expected.to have_css 'form#jira-setup-database' }
      it { is_expected.to have_selector :radio_button, 'jira-setup-database-field-database-internal' }
    end

    context 'when processing database setup' do
      # before :all do
      #   within 'form#jira-setup-database' do
      #     choose 'jira-setupwizard-database-internal'
      #     click_button 'Next'
      #   end
      # end

      # it { expect(current_path).to match '/secure/SetupApplicationProperties!default.jspa' }
      # it { is_expected.to have_title 'Your Company JIRA - JIRA Setup' }
      # it { is_expected.to have_content 'Set Up Application Properties' }
    end

    context 'when processing application properties setup' do
      # before :all do
      #   within '#jira-setupwizard' do
      #     fill_in 'title', with: 'JIRA Test instance'
      #     choose 'jira-setupwizard-mode-public'
      #     click_button 'Next'
      #   end
      # end

      # it { expect(current_path).to match '/secure/SetupProductBundle!default.jspa' }
      # it { is_expected.to have_title 'JIRA Test instance - JIRA Setup' }
      # it { is_expected.to have_content 'Customize Your Installation' }
      # it { is_expected.to have_content 'Project tracking' }
    end

    context 'when processing product bundle setup' do
      # before :all do
      #   within '#jira-setupwizard' do
      #     find(:css, 'div[data-choice-value=TRACKING]').trigger('click')
      #     click_button 'Next'
      #   end
      # end

      # it { expect(current_path).to match '/secure/SetupLicense!default.jspa' }
      # it { is_expected.to have_title 'JIRA Test instance - JIRA Setup' }
      # it { is_expected.to have_content 'Adding Your License Key' }
      # it { is_expected.to have_content 'You need a license key to set up JIRA' }
    end

    context 'when processing license setup' do
      # there's not much we can do from here from a CI point of view,
      # unless there exists a universal trial license which would work
      # with all possible Server ID's.
    end
  end

  describe 'Stopping the JIRA instance' do
    before(:all) { @container.kill_and_wait signal: 'SIGTERM' }

    it 'should shut down successful' do
      # give the container up to 5 minutes to successfully shutdown
      # exit code: 128+n Fatal error signal "n", ie. 143 = fatal error signal
      # SIGTERM
      is_expected.to include_state 'ExitCode' => 143, 'Running' => false
    end

    include_examples 'a clean console'
    include_examples 'a clean logfile', '/var/local/atlassian/jira/log/atlassian-jira.log'
  end
end
