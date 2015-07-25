angular.module('app').controller 'angCtrl', ['$scope', ($scope) ->
	$scope.families = $scope.$meteorCollection(share.Families)
	# collect all childs
	allekinder = []
	for familie in $scope.families
		for kind in familie.kinder
			k = kind
			if k.vorname?
				dobMoment = moment(k.dob, "DD.MM.YY")
				k.dobMoment = dobMoment
				console.log k
				allekinder.push k
	
	# create ang object with empty groups
	KJ = share.KiTaJahr
	currentYear = KJ.current()
	$scope.currentKiTaJahr = new KJ currentYear
	$scope.ang = []
	for i in [0...5]
		kj = new KJ currentYear + i
		$scope.ang.push
			year: kj.toString()
			startdate: kj.startDate()
			enddate: kj.endDate()
			birthDateStart: kj.birthDateStart() 
			birthDateEnd: kj.birthDateEnd() 
			groups: []

	# get child groups
	tags = $scope.$meteorCollection(share.Tags)
	$scope.childGroups = _.chain(tags).filter((t) -> t.type == 'child').map((t) -> t.name).value()
	console.log $scope.childGroups

	# collect childs into year groups
	for g in $scope.ang
		for cg in $scope.childGroups
			allOfYearAndGroup = _.filter(allekinder, (k) -> k.dobMoment.isBetween(g.birthDateStart, g.birthDateEnd) && _.some(k.tags, (t) -> t.name == cg))
			g.groups.push
				name: cg
				boys: _.filter(allOfYearAndGroup, (k) -> k.gender == 'm')
				girls: _.filter(allOfYearAndGroup, (k) -> k.gender == 'f')

	console.log $scope.ang
]