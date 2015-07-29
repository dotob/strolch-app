angular.module('app').controller 'alleCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = false
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.getFamilyName = (family) ->
		share.getFamilyName(family)
	
	$scope.archiveFamily = (family) ->
		console.log "archive id: #{family._id}"
		family.archived = true
	
	$scope.dob2age = (dob, kind) ->
		now = moment()
		dobMoment = moment(dob, "DD.MM.YY")
		age = moment.duration(now.diff(dobMoment)).years()
		if age == 1 then "1 Jahr alt" else "#{age} Jahre alt"
]