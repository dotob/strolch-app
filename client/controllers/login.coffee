angular.module('app').controller 'loginCtrl', ['$scope', '$state', ($scope, $state) ->
	$scope.demoUser = $scope.$meteorObject Meteor.users, {username: 'demo'}
	console.log $scope.demoUser
]