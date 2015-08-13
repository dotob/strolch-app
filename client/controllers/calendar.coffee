angular.module('app').controller 'calendarCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->

	$scope.newEventType = 'CLOSED'

	# stuff for calendar
	events = 
		textColor: '#000'
		color: '#efefef'
		events: []

						# event = 
						# id: r._id
						# title: "#{r.name} (#{r.member.name})"
						# start: r.from
						# end: r.to
						# allDay: true
	$scope.requestEventSources = [events]
	$scope.calendarConfig =
		calendar:
			height: 500
			editable: false
			header:
				left: 'title'
				center: ''
				right: 'today prev,next'

	# stuff for datepicker
	$scope.newDate = new Date()
	$scope.format = 'dd.MM.yyyy'
	$scope.openedFrom = false
	$scope.openedTo = false

	$scope.dateOptions =
		formatYear: 'yy'
		startingDay: 1

	$scope.openFrom = ($event) ->
		$event.preventDefault()
		$event.stopPropagation()
		$scope.openedFrom = true
	$scope.openTo = ($event) ->
		$event.preventDefault()
		$event.stopPropagation()
		$scope.openedTo = true

]
