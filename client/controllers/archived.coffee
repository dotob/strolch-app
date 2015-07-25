angular.module('app').controller 'archivedCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = true
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.undeleteFamily = (family) ->
		console.log "unarchive id: #{family._id}"
		family.archived = false
	$scope.deleteFamily = (family) ->
		if $window.confirm 'Wirklich endgültig löschen?'
			console.log "delete id: #{family._id}"
			$scope.families.remove family
]