describe 'Docker image building' do
  context 'when validating host software' do
    it 'should supported version' do
      expect { Docker.validate_version! }.to_not raise_error
    end
  end

  context 'when building image' do
    subject { Docker::Image.build_from_dir '.' }

    it { is_expected.to_not be_nil }
    it { is_expected.to have_exposed_port tcp: 8080 }
    it { is_expected.to_not have_exposed_port udp: 8080 }
    it { is_expected.to have_volume '/var/atlassian/jira' }
    it { is_expected.to have_volume '/opt/atlassian/jira/logs' }
    it { is_expected.to have_working_directory '/var/atlassian/jira' }
  end
end
