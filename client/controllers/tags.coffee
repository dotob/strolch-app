angular.module('app').controller 'tagsCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.tags = $scope.$meteorCollection(share.Tags)

	$scope.deleteTag = (tag) ->
		console.log "delete id: #{tag._id}"
		$scope.tags.remove tag

	$scope.addTag = (tagName) ->
		$scope.tags.push {name: tagName, canEdit: true}
		$scope.newName = null
]