Contributing to docker-atlassian-jira
=====================================
Looking to contribute something to docker-atlassian-jira? **Here's how you can help.**

Please take a moment to review this document in order to make the contribution
process easy and effective for everyone involved.

Following these guidelines helps to communicate that you respect the time of
the developers managing and developing this open source project. In return,
they should reciprocate that respect in addressing your issue or assessing
patches and features.

Using the issue tracker
-----------------------
When [reporting bugs][reporting-bugs] the
[issue tracker on GitHub][issue-tracker] is the recommended channel to use.

Reporting bugs with docker-atlassian-jira
-----------------------------------------
We really appreciate clear bug reports that _consistently_ show an issue
_within docker-atlassian-jira_.

The ideal bug report follows these guidelines:

1. **Use the [GitHub issue search][issue-search]** &mdash; Check if the issue
   has already been reported.
2. **Isolate the problem**  &mdash; Try to create an
   [isolated test case][isolated-case] that consistently reproduces the problem.

Please try to be as detailed as possible in your bug report, especially if an
isolated test case cannot be made. Some useful questions to include the answer
to are:

- What steps can be used to reproduce the issue?
- What is the bug and what is the expected outcome?
- What container image tag is used?
- What browser(s) and Operating System have you tested with?
- What container parameters are used to run the image instance?
- Does the bug happen consistently?
- Are you using docker-atlassian-jira with other plugins?

All of these questions will help others fix and identify any potential bugs.

Contributing changes to docker-atlassian-jira
---------------------------------------------
docker-atlassian-jira is made up of a Dockerfile and an RSpec test suite and you will need both [Docker][docker] and [Ruby][ruby] installed on your system along with the dependencies specified in the Gemfile.

In order to build and serve the documentation, you need to have [Jekyll][jekyll]
installed on your system and checkout the `gh-pages` branch.

### Building the docker-atlassian-jira image

docker-atlassian-jira uses [Docker][docker] to build the container image.

```bash
cd /path/to/docker-atlassian-jira/repo
docker build -t 'jira' .
```

### Running tests

docker-atlassian-jira uses the [Ruby][ruby] [RSpec][rspec] gem to perform acceptance tests on the built image.

```bash
cd /path/to/docker-atlassian-jira/repo
bundle exec rspec
```

### Submitting a pull request

We use GitHub's pull request system for submitting patches. Here are some
guidelines to follow when creating the pull request for your fix.

1. Make sure to create a ticket for your pull request. This will serve as the
bug ticket, and any discussion about the bug will take place there. Your pull
request will be focused on the specific changes that fix the bug.
2. Make sure to reference the ticket you are fixing within your pull request.
This will allow us to close off the ticket once we merge the pull request, or
follow up on the ticket if there are any related blocking issues.
3. Explain why the specific change was made. Not everyone who is reviewing your
pull request will be familiar with the problem it is fixing.
4. Run your tests first. If your tests aren't passing, the pull request won't
be able to be merged. If you're breaking existing tests, make sure that you
aren't causing any breaking changes.

By following these steps, you will make it easier for your pull request to be
reviewed and eventually merged.

Licensing
---------

It should also be made clear that **all code contributed to docker-atlassian-jira** must be
licensable under the [MIT license][licensing].  Code that cannot be released
under this license **cannot be accepted** into the project.

[issue-search]: https://github.com/cptactionhank/docker-atlassian-jira/search?q=&type=Issues
[issue-tracker]: https://github.com/cptactionhank/docker-atlassian-jira/issues
[licensing]: https://github.com/cptactionhank/docker-atlassian-jira/blob/master/LICENSE
[contributing]: https://github.com/cptactionhank/docker-atlassian-jira/blob/master/CONTRIBUTING.md
[reporting-bugs]: #reporting-bugs
[docker]: https://www.docker.com/
[jekyll]: https://jekyllrb.com/docs/installation/
[ruby]: https://www.ruby-lang.org/en/
[rspec]: http://rspec.info/
