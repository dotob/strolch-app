angular.module('app').controller 'hoursCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	KJ = share.KiTaJahr
	currentYear = KJ.current()
	kj = new KJ currentYear

	$scope.currentYear = KJ.current()
	$scope.sortType = 'hours'
	$scope.sortReverse = true

	updateHours = () ->
		$scope.warningLimit = 0.5
		$scope.hoursPerMonth = 2.5
		$scope.startOfKitaYear = kj.startDate()
		$scope.endOfKitaYear = kj.endDate()

		now = moment()
		if now.isBefore($scope.startOfKitaYear)
			$scope.monthsOfKitaYear = 0
		else if now.isAfter($scope.endOfKitaYear)
			$scope.monthsOfKitaYear = 12
		else # is between
			$scope.monthsOfKitaYear = moment.duration(now.diff($scope.startOfKitaYear)).months()

		console.log "kitajahr: #{$scope.startOfKitaYear.format()} => #{$scope.endOfKitaYear.format()}"

		allHours = $scope.$meteorCollection () -> share.Hours.find
			date:
				$gte: $scope.startOfKitaYear.toDate()
				$lt:  $scope.endOfKitaYear.toDate()

		$scope.hours = []
		for k, v of _.groupBy(allHours, (h) -> h.family)
			hoursSum = _.sum(v, (h) -> h.hours)
			th = $scope.monthsOfKitaYear * share.parentCount($meteor.object(share.Families, k)) * $scope.hoursPerMonth
			$scope.hours.push
				familyName: _.first(v)?.familyName
				hours: hoursSum
				targetHours: th
				severity: if hoursSum < th*$scope.warningLimit then 'warning' else 'info'

		console.log $scope.hours

		max = _.max $scope.hours, (h) -> h.hours

		for h in $scope.hours
			#h.hoursPercentage = 100.0 / (max.hours / h.hours)
			h.hoursPercentage = 100.0 / (h.targetHours / h.hours)

		ny = "#{$scope.currentYear+1}".substring 2 
		$scope.currentYearString = "#{$scope.currentYear}/#{ny}"

		$scope.hoursSum = _.sum allHours, (h) -> h.hours

	updateHours()

	$scope.goToPreviousYear = () ->
		$scope.currentYear--
		updateHours()
	$scope.goToNextYear = () ->
		$scope.currentYear++
		updateHours()
]