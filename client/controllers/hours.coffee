_ = lodash

angular.module('app').controller 'hoursCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	KJ = share.KiTaJahr
	$scope.settings = $scope.$meteorObject share.Settings, {}
	$scope.currentYear = KJ.current $scope.settings
	$scope.sortType = 'hours'
	$scope.sortReverse = true

	updateHours = () ->
		$scope.kj = new KJ $scope.currentYear, $scope.settings
		$scope.warningLimit = 0.5
		$scope.hoursPerMonth = $scope.settings.hoursPerFamilyAndMonth/2
		$scope.startOfKitaYear = $scope.kj.startDate()
		$scope.endOfKitaYear = $scope.kj.endDate()

		now = moment()
		if now.isBefore($scope.startOfKitaYear)
			$scope.monthsOfKitaYear = 0
		else if now.isAfter($scope.endOfKitaYear)
			$scope.monthsOfKitaYear = 12
		else # is between
			$scope.monthsOfKitaYear = moment.duration(now.diff($scope.startOfKitaYear)).months()

		console.log "kitajahr: #{$scope.startOfKitaYear.format()} => #{$scope.endOfKitaYear.format()}"

		$scope.allHours = $scope.$meteorCollection () -> share.Hours.find
			date:
				$gte: $scope.startOfKitaYear.toDate()
				$lt:  $scope.endOfKitaYear.toDate()

		$scope.hours = []
		for k, v of _.groupBy($scope.allHours, (h) -> h.family)
			hoursSum = _.sum(v, (h) -> h.hours)
			th = $scope.monthsOfKitaYear * share.parentCount($meteor.object(share.Families, k)) * $scope.hoursPerMonth
			$scope.hours.push
				familyName: _.first(v)?.familyName
				hours: hoursSum
				targetHours: th
				severity: if hoursSum < th*$scope.warningLimit then 'warning' else 'info'

		max = _.max $scope.hours, (h) -> h.hours

		for h in $scope.hours
			#h.hoursPercentage = 100.0 / (max.hours / h.hours)
			h.hoursPercentage = 100.0 / (h.targetHours / h.hours)

		ny = "#{$scope.currentYear+1}".substring 2 
		$scope.currentYearString = "#{$scope.currentYear}/#{ny}"

		$scope.hoursSum = _.sum $scope.allHours, (h) -> h.hours

	updateHours()

	$scope.goToPreviousYear = () ->
		$scope.currentYear--
		updateHours()

	$scope.goToNextYear = () ->
		$scope.currentYear++
		updateHours()
]