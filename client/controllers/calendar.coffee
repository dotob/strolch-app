angular.module('app').controller 'calendarCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->

	updateEvents = () ->
		console.log "update events"
		closedEvents.events.splice(0, closedEvents.events.length)
		eventEvents.events.splice(0, eventEvents.events.length)
		jubiEvents.events.splice(0, jubiEvents.events.length)
		closedEvents.events = $scope.$meteorCollection () -> share.Events.find {type: 'CLOSED'}
		eventEvents.events = $scope.$meteorCollection () -> share.Events.find {type: 'EVENT'}
		jubiEvents.events = $scope.$meteorCollection () -> share.Events.find {type: 'JUBI'}

	$scope.newEventType = 'CLOSED'

	# stuff for calendar
	closedEvents = 
		textColor: '#fff'
		color: '#D46A6A'
		events: []
	eventEvents = 
		textColor: '#fff'
		color: '#A5C663'
		events: []
	jubiEvents = 
		textColor: '#fff'
		color: '#699'
		events: []

						# event = 
						# id: r._id
						# title: "#{r.name} (#{r.member.name})"
						# start: r.from
						# end: r.to
						# allDay: true
	$scope.eventSources = [closedEvents, eventEvents, jubiEvents]
	$scope.calendarConfig =
		calendar:
			height: 500
			editable: false
			header:
				left: 'title'
				center: ''
				right: 'today prev,next'

	updateEvents()

	# stuff for datepicker
	$scope.newDateFrom = new Date()
	$scope.newDateTo = new Date()
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

	$scope.addEvent = () ->
		e = 
			title: $scope.newTitle
			start: $scope.newDateFrom
			end: $scope.newDateTo
			type: $scope.newEventType

		$scope.$meteorCollection(share.Events).save(e).then (inserts) ->
			e = _.first(inserts)
			console.log "inserted new event with id: #{e._id}"
			console.log e
			updateEvents()
]
