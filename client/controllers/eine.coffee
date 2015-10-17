_ = lodash

angular.module('app').controller 'eineCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	console.log $scope.family
	$scope.tags = $scope.$meteorCollection(share.Tags)
	$scope.loadTags = (query) ->
		# filter
		tags = _.filter $scope.tags, (t) -> t.name? && t.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
		_.sortBy tags, (t) -> t.name

	$scope.deleteChild = (idx) ->
		console.log "delete child #{idx}"
		delete $scope.family.kinder["#{idx}"]
		if idx == 0
			$scope.family.kinder['0'] = $scope.family.kinder['1']
			delete $scope.family.kinder['1']
		if idx <= 1
			$scope.family.kinder['1'] = $scope.family.kinder['2']
			delete $scope.family.kinder['2']

	$scope.format = 'dd.MM.yyyy'
	$scope.status = 
		opened: [false, false, false]

	$scope.dateOptions =
		formatYear: 'yy'
		startingDay: 1

	$scope.openDob = ($event, idx) ->
		$event.preventDefault()
		$event.stopPropagation()
		$scope.status.opened[idx] = true


]