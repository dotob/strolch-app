angular.module('app').controller 'navCtrl', ['$scope', '$meteor', '$rootScope', ($scope, $meteor, $rootScope) ->
	$scope.userIsAdmin = $rootScope.currentUser.profile?.isAdmin || false
]