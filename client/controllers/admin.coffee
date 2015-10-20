_ = lodash

angular.module('app').controller 'adminCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.users = $scope.$meteorCollection Meteor.users
	$scope.tags = $scope.$meteorCollection share.Tags
	$scope.settings = $scope.$meteorObject share.Settings, {}
	$scope.newEventTypeColor = '#000'

	$scope.sampleColors = (color) ->
		console.log "input color: #{color}"
		colors = tinycolor(color).splitcomplement()
		console.log colors
		someColors = colors.map (t) -> t.toHexString()
		console.log someColors
		mostReadable = tinycolor.mostReadable(color, someColors, {includeFallbackColors: true, level: "AA", size: "small"})
		readableColor = mostReadable?.toHexString() || '#fff'
		console.log "readableColor: #{color} => #{readableColor}"
		{ "color": readableColor, "background-color": color}

	$scope.createUser = (newUserName, newUserPassword, newUserAdmin) ->
		console.log "create new user #{newUserName}"
		Meteor.call 'createNewUser', newUserName, newUserPassword, newUserAdmin

	$scope.deleteUser = (user) ->
		console.log "remove user #{user._id}"
		Meteor.users.remove user._id

	$scope.changePasswort = (user) ->
		newPassWord = $window.prompt "Neues Passwort eingeben"
		console.log "set new password"
		Meteor.call 'setPassword', user._id, newPassWord

	$scope.createTag = (newTagName, newTagChildGroup, newTagCanEdit) ->
		if newTagChildGroup then type = "child" else type = "parent"
		console.log "create new tag "
		$scope.tags.push 
			name: newTagName
			canEdit: newTagCanEdit
			type: type

	$scope.deleteTag = (tag) ->
		console.log "remove tag #{tag._id}"
		$scope.tags.remove tag

	$scope.createEventType = (key, name, color) ->
		console.log "new event type: #{key}:#{name}:#{color}"
		if !$scope.settings.eventTypes
			$scope.settings.eventTypes = []
		console.log $scope.settings.eventTypes	
		$scope.settings.eventTypes.push 
			key: key
			name: name
			color: color
		$scope.newEventTypeName = ""
		$scope.newEventTypeKey = ""

	$scope.deleteEventType = (eventType) ->
		console.log "delete eventType: #{eventType.key}:#{eventType.name}:#{eventType.color}"
		ets = angular.copy $scope.settings.eventTypes
		_.remove ets, (et) -> et.key == eventType.key
		$scope.settings.eventTypes = ets
		console.log ets
		console.log $scope.settings.eventTypes

	$scope.doImport = (files) ->
		if files.length > 0
			f = files[0]
			$scope.reader = new FileReader()
			$scope.reader.onload = $scope.readImportFileAndImport
			$scope.reader.readAsText f

	$scope.readImportFileAndImport = () ->
		json = $scope.reader.result
		importData = JSON.parse json
		console.log importData
		if $window.confirm 'Import löscht alle vorhandenen Daten. Fortfahren?'
			families = $scope.$meteorCollection share.Families
			hours = $scope.$meteorCollection share.Hours
			events = $scope.$meteorCollection share.Events
			settings = $scope.$meteorCollection share.Settings
			tags = $scope.$meteorCollection share.Tags
			# remove all data
			families.remove()
			hours.remove()
			events.remove()
			settings.remove()
			tags.remove()
			# insert all, need to remove some nonimportable fields
			count = 0
			if importData.families
				for i in importData.families
					count++
					$scope.cleanImportObject i
				families.save importData.families
			if importData.hours
				for i in importData.hours
					count++
					$scope.cleanImportObject i
					i.date = new Date(i.date)
				hours.save importData.hours
			if importData.events
				for i in importData.events
					count++
					$scope.cleanImportObject i
					i.start = new Date(i.start)
					i.end = new Date(i.end)
				events.save importData.events
			if importData.settings
				for i in importData.settings
					count++
					$scope.cleanImportObject i
				settings.save importData.settings
			if importData.tags
				for i in importData.tags
					count++
					$scope.cleanImportObject i
				tags.save importData.tags
			$window.alert "#{count} Datensätze importiert"
	
	$scope.cleanImportObject = (o) ->
		delete o.createdAt
		delete o.createdBy
		delete o.updatedAt
		delete o.updatedBy
	
	$scope.doExport = () ->
		console.log "start export"
		exportData = 
			families: $scope.$meteorCollection share.Families
			hours: $scope.$meteorCollection share.Hours
			events: $scope.$meteorCollection share.Events
			settings: $scope.$meteorCollection share.Settings
			tags: $scope.$meteorCollection share.Tags
		console.log "created export data"
		console.log exportData
		json = JSON.stringify exportData, null, 2
		b = new Blob [json], { type : 'text/plain' }
		$scope.exportUrl = ($window.URL || $window.webkitURL).createObjectURL( b )
		console.log "set exportUrl=#{$scope.exportUrl}"
]