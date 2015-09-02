var app = angular.module('docker-configurator', []);

app.run(function($rootScope) {

	// configuration constants for the various Atlassian JIRA docker images
	// where each key defines the most recent version that had that specific
	// configuration. For example the key 6.4.5 defines the most recent
	// image that supported that configuration and finding a configuration for
  // a specific image version the list of configurations should be sorted by
  // key and then filtered by `<= [selected version]` and the largest key
  // should then be used as the current configuration.
	$rootScope.configurations = {
		// for configurations <= 6.4.5
		'6.4.5': {
			home: '/var/local/atlassian/jira',
			install: '/usr/local/atlassian/jira'
		},
		// define the default fall-back value of Docker image configuration
		// settings, by using the highest available unicode character.
		'\uDFFF': {
			home: '/var/atlassian/jira',
			install: '/opt/atlassian/jira'
		}
	}

	$rootScope.jira = {
		home: 'not set',
		install: 'not set'
	}

	$rootScope.update = function(value) {
		var latest = Object.keys($rootScope.configurations).filter(function (item) { return String.naturalCompare(item, value) >= 0; })[0]
		if (latest) {
			angular.merge($rootScope.jira, $rootScope.configurations[latest]);
		}
	};

});

app.controller('ConfigurationController', function($rootScope, $scope, $http) {
	$scope.tags = [];
	$scope.status = "loading";
	// populate the controllers model with the first 1000 available tags from
	// the Docker Hub repository.
	$http
	.get('http://crossorigin.me/https://hub.docker.com/v2/repositories/cptactionhank/atlassian-jira/tags/?page_size=1000')
	.success(function(data, status) {
		$scope.tags = data.results.sort(function(a,b) { return String.naturalCompare(a.name, b.name); });
		$scope.update($scope.jira.version);
		$scope.status = "";
	}).error(function(data, status) {
		$scope.status = "error"
	});
});
