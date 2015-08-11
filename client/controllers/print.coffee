angular.module('app').controller 'printCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.showArchived = false
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
]