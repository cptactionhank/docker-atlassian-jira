describe 'Atlassian JIRA with Embedded Database' do
  include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms2048m -Xmx2048m -XX:+UseG1GC -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout} -Datlassian.darkfeature.jira.onboarding.feature.disabled=true"]

  include_examples 'an acceptable JIRA instance', 'using an embedded database'
end
