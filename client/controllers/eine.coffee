angular.module('app').controller 'eineCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	console.log $scope.family
	$scope.tags = $scope.$meteorCollection(share.Tags)
	$scope.loadTags = (query) ->
		# filter
		_.filter $scope.tags, (t) -> t.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
]