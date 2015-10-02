angular.module('app').controller 'calendarCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.newEventType = 'CLOSED'
	$scope.events = $scope.$meteorCollection () -> share.Events.find()
	$scope.settings = $scope.$meteorObject share.Settings, {}

	$meteor.requireValidUser (user) ->
		userIsAdmin = user?.profile?.isAdmin || false
		onlyAdmin = $scope.settings.onlyAdminCanEditEvents
		$scope.canEditEvents = !onlyAdmin || userIsAdmin
		console.log "user #{user.username} is admin: #{userIsAdmin} and onlyAdminCanEditEvents=#{onlyAdmin}"

	# stuff for calendar
	closedEvents = 
		textColor: '#fff'
		color: '#D46A6A'
		events: $scope.$meteorCollection () -> share.Events.find {type: 'CLOSED'}
	eventEvents = 
		textColor: '#fff'
		color: '#A5C663'
		events: $scope.$meteorCollection () -> share.Events.find {type: 'EVENT'}
	jubiEvents = 
		textColor: '#fff'
		color: '#699'
		events: $scope.$meteorCollection () -> share.Events.find {type: 'JUBI'}

	$scope.eventSources = [closedEvents, eventEvents, jubiEvents]
	$scope.calendarConfig =
		calendar:
			height: 500
			editable: false
			timeFormat: 'H(:mm)'
			header:
				left: 'title'
				center: ''
				right: 'today prev,next'

	# stuff for datepicker
	$scope.newDateFrom = new Date()
	$scope.newDateTo = new Date()
	$scope.newTimeFrom = new Date()
	$scope.newTimeTo = new Date()
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

	$scope.deleteEvent = (event) ->
		console.log "remove event: #{event.title}"
		$scope.$meteorCollection(share.Events).remove event

	$scope.addEvent = (newTitle, newEventType, newDateFrom, newDateToEntered, newDateTo, newTimeFrom, newTimeTo) ->
		console.log "create new event: #{newTitle}, #{newDateFrom} #{newTimeFrom} - #{newDateTo} #{newTimeTo}, #{newEventType}"
		if newDateToEntered
			endDate = new Date newDateTo.getFullYear(), newDateTo.getMonth(), newDateTo.getDate(), newTimeTo.getHours(), newTimeTo.getMinutes()
		else
			endDate = null
		e = 
			title: newTitle
			start: new Date newDateFrom.getFullYear(), newDateFrom.getMonth(), newDateFrom.getDate(), newTimeFrom.getHours(), newTimeFrom.getMinutes()
			end: endDate
			type: newEventType 
		console.log e
		$scope.$meteorCollection(share.Events).save(e).then (inserts, e) ->
			if e 
				console.log e
			i = _.first(inserts)
			console.log "inserted new event with id: #{i._id}"
]
