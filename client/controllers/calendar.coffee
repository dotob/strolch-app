angular.module('app').controller 'calendarCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->

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
	$scope.opened = false

	$scope.dateOptions =
		formatYear: 'yy'
		startingDay: 1

	$scope.open = ($event) ->
		$event.preventDefault()
		$event.stopPropagation()
		$scope.opened = true

]
