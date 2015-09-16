angular.module('app').controller 'navCtrl', ['$scope', '$meteor', '$rootScope', ($scope, $meteor, $rootScope) ->
	$scope.updateAdmin = () ->
		$meteor.requireValidUser (user) ->
			$scope.userIsAdmin = user?.profile?.isAdmin || false
			console.log "user #{user.username} is admin: #{$scope.userIsAdmin}"

	$scope.updateAdmin()		
]