angular.module('app').controller 'neuCtrl', ['$scope', '$state', ($scope, $state) ->
	$scope.isNew = true
	$scope.family = {}
	$scope.save = () ->
		$scope.family.archived = false
		console.log "save new family: #{JSON.stringify($scope.family)}"
		$scope.$meteorCollection(share.Families).save($scope.family).then (inserts) ->
			id = _.first(inserts)._id
			console.log "inserted new family with id:#{id}"
			$state.go 'eine', {id: id}
]