_ = lodash

angular.module('app').controller 'addHoursCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	$scope.familyName = share.getFamilyName $scope.family
	$scope.hours = $scope.$meteorCollection(() -> share.Hours.find({family: $scope.family._id}))
	$scope.hoursSum = _.sum($scope.hours, (h) -> h.hours)
	
	$scope.addHours = (newWork, newDate, newHours) ->
		$scope.$meteorCollection(share.Hours).save 
			activity: newWork
			date: newDate
			hours: newHours
			family: $scope.family._id
			familyName: $scope.familyName
		$scope.hoursSum += newHours

	$scope.deleteHour = (hour) ->
		console.log "delete hour: #{hour._id}"
		$scope.$meteorCollection(share.Hours).remove hour


	$scope.newDate = new Date()
	$scope.format = 'dd.MM.yyyy'
	$scope.opened = false

	$scope.dateOptions =
		formatYear: 'yy'
		startingDay: 1

	$scope.open = ($event) ->
		$event.preventDefault()
		$event.stopPropagation()
		$scope.opened = true
]