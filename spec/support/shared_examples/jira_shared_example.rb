shared_examples 'an acceptable JIRA instance' do |database_examples|
  describe 'Going through the setup process' do
    before :all do
      until current_path =~ %r{/secure/SetupMode!default.jspa}
        visit '/'
        sleep 1
      end
    end

    subject { page }

    context 'when visiting the root page' do
      it { is_expected.to have_current_path %r{/secure/SetupMode!default.jspa} }
      it { is_expected.to have_css 'form#jira-setup-mode' }
      it { is_expected.to have_css 'div[data-choice-value=classic]' }
    end

    context 'when manually setting up the instance' do
      before :all do
        within 'form#jira-setup-mode' do
          find(:css, 'div[data-choice-value=classic]').trigger('click')
          click_button 'Next'
          wait_for_ajax
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupDatabase!default.jspa} }
      it { is_expected.to have_css 'form#jira-setup-database' }
      it { is_expected.to have_selector :radio_button, 'jira-setup-database-field-database-internal' }
      it { is_expected.to have_button 'Next' }
    end

    context 'when processing database setup' do
      include_examples database_examples

      it { is_expected.to have_current_path %r{/secure/SetupApplicationProperties!default.jspa} }
      it { is_expected.to have_css 'form#jira-setupwizard' }
      it { is_expected.to have_field 'title' }
      it { is_expected.to have_selector :radio_button, 'jira-setupwizard-mode-public' }
      it { is_expected.to have_button 'Next' }
    end

    context 'when processing application properties setup' do
      before :all do
        within 'form#jira-setupwizard' do
          fill_in 'title', with: 'JIRA Test instance'
          choose 'jira-setupwizard-mode-public'
          click_button 'Next'
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupLicense!default.jspa} }
      it { is_expected.to have_css 'form#jira-setupwizard' }
      it { is_expected.to have_css '#importLicenseForm' }
    end

    context 'when processing license setup' do
      before :all do
        within '#jira-setupwizard' do
          within '#importLicenseForm' do
            fill_in 'licenseKey', with: 'AAABiQ0ODAoPeNp1kk9TwjAQxe/9FJnxXKYpeoCZHqCtgsqfgaIO4yWELURD0tm0KN/eWOjYdvD68vbtb3dzM9GKTBgS2iOU9n3a7/pkHiXE96jvbNhho3XnWXBQBuKtyIVWQTxN4sV8MV7GTirMHk5QOZJTBsG91eITvPdJBEeQOgN0uNRHwIYtLKWGa1ocNoCzdGUATUA9h2uVdhjPxRGCHAtw5gXyPTMQsRwCn1Lf9XzXv3NqwVN2gGCZDBYWstLj70zgqSyad0fVWPXgJaClGUfB8KGXuG+rl1v3ab0euUOPvjofAlmD/XG8GJBY5YAZCtMa9Ze5MagVZAGKX/FVE4eyMDZtqrdgAq+19zJlWEr/Na0TXjkTx4KLjWzeKbyIjaAJE7aDYpa2tTSO+mvbCrBKo/ryate4Up9KfylnhjumhGEl0SCXzBjB1B9Q/QYhQulrH/fcue6svl1di8BwFFnZKAGTE3mGIalGksliJxTZVqTmvLF6fXxksjhzpkwaqP5s3fMDBMYhRDAtAhUAhcR3uL05YCxbclq7h1dNa+Nc+j4CFBrdN005oVlMN9yBlWeM4TlnrOhqX02j3'
            click_button 'Next'
            wait_for_location_change
          end
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupAdminAccount!default.jspa} }
      it { is_expected.to have_field 'fullname' }
      it { is_expected.to have_field 'email' }
      it { is_expected.to have_field 'username' }
      it { is_expected.to have_field 'password' }
      it { is_expected.to have_field 'confirm' }
    end

    context 'when processing administrative account setup' do
      before :all do
        within '#jira-setupwizard' do
          fill_in 'fullname', with: 'Continuous Integration Administrator'
          fill_in 'email', with: 'jira@circleci.com'
          fill_in 'username', with: 'admin'
          fill_in 'password', with: 'admin'
          fill_in 'confirm', with: 'admin'
          click_button 'Next'
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupAdminAccount.jspa} }
      it { is_expected.to have_selector :radio_button, 'jira-setupwizard-email-notifications-enabled' }
      it { is_expected.to have_selector :radio_button, 'jira-setupwizard-email-notifications-disabled' }
    end

    context 'when processing email notifications setup' do
      before :all do
        within '#jira-setupwizard' do
          choose 'jira-setupwizard-email-notifications-disabled'
          click_button 'Finish'
        end
      end

      it { is_expected.to have_current_path %r{/secure/Dashboard.jspa} }

      # The acceptance testing comes to an end here since we got to the
      # JIRA dashboard without any trouble through the setup.
    end
  end

  describe 'Stopping the JIRA instance' do
    before(:all) { @container.kill_and_wait signal: 'SIGTERM' }

    subject { @container }

    it 'should shut down successful' do
      # give the container up to 5 minutes to successfully shutdown
      # exit code: 128+n Fatal error signal "n", ie. 143 = fatal error signal
      # SIGTERM
      #
      # The following state check has been left out 'ExitCode' => 143 to
      # suppor CircleCI as CI builder. For some reason whether you send SIGTERM
      # or SIGKILL, the exit code is always 0, perhaps it's the container
      # driver
      is_expected.to include_state 'Running' => false
    end

    include_examples 'a clean console'
    include_examples 'a clean logfile', '/var/atlassian/jira/log/atlassian-jira.log'
  end
end
