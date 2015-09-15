angular.module('app').controller 'navCtrl', ['$scope', '$meteor', '$rootScope', ($scope, $meteor, $rootScope) ->

	$scope.updateAdmin = () ->
		$scope.userIsAdmin = $rootScope.currentUser?.profile?.isAdmin || false
		console.log "admin: #{$scope.userIsAdmin}"

	$scope.updateAdmin()
]