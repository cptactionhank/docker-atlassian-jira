var app = angular.module('dockerConfigurator', []);

app.filter('prefix', function () {
  return function (value, prefix) {
    if (value) {
      return prefix + value;
    } else {
      return undefined;
    }
  };
});

app.run(function($rootScope) {

  // configuration constants for the various Atlassian JIRA docker images
  // where each key defines the most recent version that had that specific
  // configuration. For example the key 5.8.2 defines the most recent
  // image that supported that configuration and finding a configuration for
  // a specific image version the list of configurations should be sorted by
  // key and then filtered by `<= [selected version]` and the largest key
  // should then be used as the current configuration.
  $rootScope.configurations = {
    // define the default fall-back value of Docker image configuration
    // settings, by using the highest available unicode character.
    '': {
      home: '/var/local/atlassian/jira',
      install: '/usr/local/atlassian/jira',
      java: 7
    },
    '6.4.6': {
      home: '/var/atlassian/jira',
      install: '/opt/atlassian/jira',
      java: 8
    }
  };

  $rootScope.jira = {
    home: 'not set',
    install: 'not set',
    version: { name:'latest' },
    java: 'latest',
    port: 8080
  };

  $rootScope.update = function(tag) {
    var args = Object.keys($rootScope.configurations).filter(function(item) {
      return item === tag.name || !! item.match(/^|([0-9]+(\.[0-9]+)+)$/);
    }).filter(function(item) {
      return String.naturalCompare(item, tag.name) <= 0;
    }).map(function(item) {
      return $rootScope.configurations[item];
    });
    args.unshift($rootScope.jira);
    $rootScope.jira = angular.merge.apply(undefined, args);
  };

});

app.controller('ConfigurationController', function($rootScope, $scope, $http) {
  $scope.tags = [];
  $scope.status = "loading";
  // populate the controllers model with the first 1000 available tags from
  // the Docker Hub repository.
  $http
    .get('//crossorigin.me/https://hub.docker.com/v2/repositories/cptactionhank/atlassian-jira/tags/?page_size=1000')
    .success(function(data, status) {
      $scope.tags = data.results.sort(function(a, b) {
        return String.naturalCompare(a.name, b.name);
      });
      // set the latest tag as the default selected
      $rootScope.jira.version = $scope.tags.filter(function(item) {
        return item.name === 'latest';
      }).pop();
      // update the bindings with the latest version tag
      $scope.update($rootScope.jira.version);
      $scope.status = "";
  }).error(function(data, status) {
    $scope.status = "error"
  });
});

// it is needed to first perform syntax highlighting and only after this
// bootstrapping the Angular application. This is caused by highlightjs is
// rebuilding the html and this Angular will need to re-bind all the
// databindings.
hljs.initHighlighting();

angular.element(document).ready(function() {
  angular.bootstrap(document, ["dockerConfigurator"]);
});
