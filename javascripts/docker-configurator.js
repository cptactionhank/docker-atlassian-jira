
var app = angular.module('docker-configurator', []);

app.run(function($rootScope) {

	$rootScope.jira = {
		home: '/var/atlassian/jira',
		install: '/opt/atlassian/jira'
	};

	$rootScope.update = function(value) {
		console.log('selected value: ' + value);
	};

});

app.controller('ConfigurationController', function($rootScope, $scope, $http) {
	$scope.tags = [];
	$scope.status = "loading";
	// populate the controllers model with the first 1000 available tags from
	// the Docker Hub repository.
	$http
	.get('http://cors.io/?u=https://hub.docker.com/v2/repositories/cptactionhank/atlassian-jira/tags/?page_size=1000')
	.success(function(data, status) {
		$scope.tags = data.results;
		$scope.update($scope.jira.version);
		$scope.status = "";
	}).error(function(data, status) {
		$scope.status = "error"
	});
});
