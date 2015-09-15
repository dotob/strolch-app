_ = lodash

angular.module('app').controller 'adminCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.users = $scope.$meteorCollection Meteor.users
	$scope.settings = $scope.$meteorObject share.Settings, {}

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
		# TODO: import data
	
	$scope.doExport = () ->
		console.log "start export"
		exportData = 
			families: $scope.$meteorCollection share.Families
			hours: $scope.$meteorCollection share.Hours
			events: $scope.$meteorCollection share.Events
			settings: $scope.$meteorCollection share.Settings
			families: $scope.$meteorCollection share.Families
		console.log "created export data"
		console.log exportData
		json = JSON.stringify exportData, null, 2
		b = new Blob [json], { type : 'text/plain' }
		$scope.exportUrl = ($window.URL || $window.webkitURL).createObjectURL( b )
		console.log "set exportUrl=#{$scope.exportUrl}"
]