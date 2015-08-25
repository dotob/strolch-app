_ = lodash

angular.module('app').controller 'adminCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.users = $scope.$meteorCollection(Meteor.users)	
	$scope.tags = $scope.$meteorCollection(share.Tags)	

	$scope.createUser = () ->

	$scope.deleteUser = (user) ->

	$scope.changePasswort = (user) ->

	$scope.createTag = () ->

	$scope.deleteTag = () ->
		
]