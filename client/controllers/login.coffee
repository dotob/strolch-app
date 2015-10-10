angular.module('app').controller 'loginCtrl', ['$scope', '$state', ($scope, $state) ->
	demoUser = Meteor.users.findOne {username: 'demo'}
	$scope.demoMode = demoUser?
]