angular.module('app').controller 'alleCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.showArchived = false
	
	$scope.getFamilyName = (family) ->
		share.getFamilyName(family)

	$scope.getFamilyNameCount = (family) ->
		share.getFamilyNameCount(family)
	
	$scope.archiveFamily = (family) ->
		if $window.confirm 'Wirklich archivieren? Familie kann wieder aus dem Archiv geholt werden!'
			console.log "archive id: #{family._id}"
			family.archived = true
	
	$scope.dob2age = (dob, kind) ->
		if dob
			if typeof kind.dob == 'string'
				console.log "convert dob-string (#{dob}) of #{kind.vorname} #{kind.nachname} to date"
				dobMoment = moment(kind.dob, "DD.MM.YY")
				kind.dob = dobMoment.doDate()
			else
				dobMoment = moment(dob.toISOString())
			now = moment()
			age = moment.duration(now.diff(dobMoment)).years()
			if age == 1 then "1 Jahr alt" else "#{age} Jahre alt"
		else
			"n/a"
]