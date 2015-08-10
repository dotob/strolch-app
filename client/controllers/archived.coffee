angular.module('app').controller 'archivedCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = true
	$scope.families = $scope.$meteorCollection(share.Families)

	$scope.getFamilyName = (family) ->
		share.getFamilyName(family)

	$scope.getFamilyNameCount = (family) ->
		share.getFamilyNameCount(family)

	$scope.dob2age = (dob, kind) ->
		now = moment()
		dobMoment = moment(dob, "DD.MM.YY")
		age = moment.duration(now.diff(dobMoment)).years()
		if age == 1 then "1 Jahr alt" else "#{age} Jahre alt"

	$scope.undeleteFamily = (family) ->
		console.log "unarchive id: #{family._id}"
		family.archived = false

	$scope.deleteFamily = (family) ->
		if $window.confirm 'Wirklich endgültig löschen?'
			console.log "delete id: #{family._id}"
			$scope.families.remove family
]