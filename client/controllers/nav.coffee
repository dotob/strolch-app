angular.module('app').controller 'navCtrl', ['$scope', '$meteor', '$rootScope', ($scope, $meteor, $rootScope) ->
	$scope.userIsAdmin = $rootScope.currentUser?.profile?.isAdmin || false
	console.log "userisadmin: #{$scope.userIsAdmin}"
	console.log $rootScope.currentUser
]