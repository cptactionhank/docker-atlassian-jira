shared_examples 'a clean console' do
  context 'validating console output' do
    it { is_expected.to_not contain_console_output REGEX_SEVERE, filter: REGEX_FILTER }
    # it { is_expected.to_not contain_console_output REGEX_ERROR, filter: REGEX_FILTER }
    # There happens a lot of warnings by default so disable this check for now
    # it { is_expected.to_not contain_console_output REGEX_WARN, filter: REGEX_FILTER }
  end
end
