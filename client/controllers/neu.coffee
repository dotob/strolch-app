angular.module('app').controller 'neuCtrl', ['$scope', '$state', ($scope, $state) ->
	$scope.isNew = true
	$scope.family = {}
	$scope.tags = $scope.$meteorCollection(share.Tags)

	$scope.loadTags = (query) ->
		# filter
		tags = _.filter $scope.tags, (t) -> t.name? && t.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
		_.sortBy tags, (t) -> t.name

	$scope.save = () ->
		$scope.family.archived = false
		console.log "save new family: #{JSON.stringify($scope.family)}"
		$scope.$meteorCollection(share.Families).save($scope.family).then (inserts) ->
			id = _.first(inserts)._id
			console.log "inserted new family with id:#{id}"
			$state.go 'eine', {id: id}
]