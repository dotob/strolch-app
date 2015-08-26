_ = lodash

angular.module('app').controller 'adminCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.users = $scope.$meteorCollection(Meteor.users)	
	$scope.tags = $scope.$meteorCollection(share.Tags)	

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
]