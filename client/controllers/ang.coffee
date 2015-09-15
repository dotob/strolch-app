_ = lodash

angular.module('app').controller 'angCtrl', ['$scope', ($scope) ->
	$scope.settings = $scope.$meteorObject share.Settings, {}
	$scope.families = $scope.$meteorCollection () -> share.Families.find {archived: false}
	# collect all childs
	allekinder = []
	for familie in $scope.families
		for x, kind of familie.kinder
			k = kind
			if k.vorname? && k.vorname.length > 0
				dobMoment = moment(k.dob, "DD.MM.YY")
				k.dobMoment = dobMoment
				allekinder.push k
				#console.log "in: '#{k.vorname}' '#{k.nachname}' '#{familie.mama.nachname}'"
			else
				#console.log "out: '#{k.vorname}' '#{k.nachname}' '#{familie.mama.nachname}'"

	console.log "---"
	#console.table allekinder
	
	# create ang object with empty groups
	KJ = share.KiTaJahr
	currentYear = KJ.current $scope.settings
	$scope.currentKiTaJahr = new KJ currentYear, $scope.settings
	$scope.ang = []
	for i in [0..6]
		kj = new KJ currentYear + i, $scope.settings
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