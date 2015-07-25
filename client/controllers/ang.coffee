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
	for i in [0..5]
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
	$scope.childGroups = _.chain(tags).filter((t) -> t.type == 'child').map((t) -> t.name).sortBy().value()
	console.log $scope.childGroups

	# collect childs into year groups
	$scope.sumGroups = {}
	for g in $scope.ang
		sums = []
		sg = 0
		sb = 0
		sa = 0
		for cg in $scope.childGroups
			allOfYearAndGroup = _.filter(allekinder, (k) -> k.dobMoment.isBetween(g.birthDateStart, g.birthDateEnd) && _.some(k.tags, (t) -> t.name == cg))
			girls = _.filter(allOfYearAndGroup, (k) -> k.gender == 'f')
			boys = _.filter(allOfYearAndGroup, (k) -> k.gender == 'm')
			sg += girls.length
			sb += boys.length
			sa += girls.length + boys.length
			g.groups.push
				cg: cg
				gender: 'f'
				kids: girls
			g.groups.push
				cg: cg
				gender: 'm'
				kids: boys

			sums.push
				id: i
				name: 'Mädchen'
				sum: girls.length
			sums.push 
				id: i + $scope.childGroups.length
				name: 'Jungen'
				sum: boys.length

		sums.push 
			id: sums.length
			name: 'M'
			sum: sg
		sums.push 
			id: sums.length
			name: 'J'
			sum: sb
		sums.push 
			id: sums.length
			name: 'MJ'
			sum: sa

		$scope.sumGroups[g.year] = sums 
	
	# sum of all
	sums = []
	for i in [0...9]
		sums.push
			id: i
			sum: 0

	for i in [0...9]
		for k, v of $scope.sumGroups
			sums[i].sum += v[i].sum

	$scope.sumGroups['all'] = sums
	#console.log $scope.ang
]