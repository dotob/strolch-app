# meteor accounts config
accountsUIBootstrap3.setLanguage 'de'
Accounts.ui.config
	passwordSignupFields: 'USERNAME_ONLY'

# overwrite underscore with lodash
_ = lodash

# angular
app = angular.module 'app', ['angular-meteor', 'ui.router', 'ngTagsInput', 'ui.bootstrap']

# routes
userResolve = 
				"currentUser": [
					"$meteor", ($meteor) ->
						$meteor.requireUser()
				]

app.config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
	$stateProvider
		.state 'alle',
			url: '/'
			templateUrl: 'client/jade/alle.html'
			controller: 'alleCtrl'
			resolve: userResolve
		.state 'archived',
			url: '/archived'
			templateUrl: 'client/jade/alle.html'
			controller: 'archivedCtrl'
			resolve: userResolve
		.state 'neu',
			url: '/neu'
			templateUrl: 'client/jade/eine.html'
			controller: 'neuCtrl'
			resolve: userResolve
		.state 'eine',
			url: '/eine/:id'
			templateUrl: 'client/jade/eine.html'
			controller: 'eineCtrl'
			resolve: userResolve
		.state 'tags',
			url: '/tags'
			templateUrl: 'client/jade/tags.html'
			controller: 'tagsCtrl'
			resolve: userResolve
		.state 'hours',
			url: '/hours'
			templateUrl: 'client/jade/hours.html'
			controller: 'hoursCtrl'
			resolve: userResolve
		.state 'add-hours',
			url: '/add-hours/:id'
			templateUrl: 'client/jade/add-hours.html'
			controller: 'addHoursCtrl'
			resolve: userResolve
		.state 'ang',
			url: '/ang'
			templateUrl: 'client/jade/ang.html'
			controller: 'angCtrl'
			resolve: userResolve
		.state 'login',
			url: '/login'
			templateUrl: 'client/jade/login.html'
			
	$urlRouterProvider.otherwise '/'
	$locationProvider.html5Mode true
]

app.run ['$rootScope', '$state', ($rootScope, $state) ->
	Accounts.onLogin () -> $state.go 'alle'
	accountsUIBootstrap3.logoutCallback = () -> $state.go 'login'
	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		# We can catch the error thrown when the $requireUser promise is rejected
		# and redirect the user back to the main page
		if error == 'AUTH_REQUIRED'
			$state.go 'login'
]

app.controller 'neuCtrl', ['$scope', '$state', ($scope, $state) ->
	$scope.isNew = true
	$scope.family = {}
	$scope.save = () ->
		$scope.family.archived = false
		console.log "save new family: #{JSON.stringify($scope.family)}"
		$scope.$meteorCollection(share.Families).save($scope.family).then (inserts) ->
			id = _.first(inserts)._id
			console.log "inserted new family with id:#{id}"
			$state.go 'eine', {id: id}
]

app.controller 'alleCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = false
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.getFamilyName = (family) ->
		getFamilyName(family)
	
	$scope.archiveFamily = (family) ->
		console.log "archive id: #{family._id}"
		family.archived = true
	
	$scope.dob2age = (dob, kind) ->
		now = moment()
		dobMoment = moment(dob, "DD.MM.YY")
		age = moment.duration(now.diff(dobMoment)).years()
		if age == 1 then "1 Jahr alt" else "#{age} Jahre alt"
]

app.controller 'archivedCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = true
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.undeleteFamily = (family) ->
		console.log "unarchive id: #{family._id}"
		family.archived = false
	$scope.deleteFamily = (family) ->
		if $window.confirm 'Wirklich endgültig löschen?'
			console.log "delete id: #{family._id}"
			$scope.families.remove family
]

app.controller 'tagsCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.tags = $scope.$meteorCollection(share.Tags)
	$scope.deleteTag = (tag) ->
		console.log "delete id: #{tag._id}"
		$scope.tags.remove tag
	$scope.addTag = (tagName) ->
		$scope.tags.push {name: tagName}
		$scope.newName = null
]

app.controller 'eineCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	console.log $scope.family
	$scope.tags = $scope.$meteorCollection(share.Tags)
	$scope.loadTags = (query) ->
		# filter
		_.filter $scope.tags, (t) -> t.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
]

getFamilyName = (family) ->
	if !family.mama?.nachname or !family.papa?.nachname
		family.papa?.nachname || family.mama?.nachname
	else if family.mama.nachname == family.papa.nachname
		family.papa.nachname
	else
		"#{family.mama.nachname} & #{family.papa.nachname}"

parentCount = (family) ->
	if !family.mama.nachname or !family.papa.nachname
		1
	else
		2

app.controller 'addHoursCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	$scope.familyName = getFamilyName $scope.family
	$scope.hours = $scope.$meteorCollection(() -> share.Hours.find({family: $scope.family._id}))
	$scope.hoursSum = _.sum($scope.hours, (h) -> h.hours)
	
	$scope.addHours = (newWork, newDate, newHours) ->
		$scope.$meteorCollection(share.Hours).save 
			activity: newWork
			date: newDate
			hours: newHours
			family: $scope.family._id
			familyName: $scope.familyName
		$scope.hoursSum += newHours

	$scope.deleteHour = (hour) ->
		console.log "delete hour: #{hour._id}"
		$scope.$meteorCollection(share.Hours).remove hour


	$scope.newDate = new Date()
	$scope.format = 'dd.MM.yyyy'

	$scope.dateOptions =
		formatYear: 'yy'
		startingDay: 1

	$scope.open = ($event) ->
		$event.preventDefault()
		$event.stopPropagation()
		$scope.opened = true
]

app.controller 'hoursCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.currentYear = 2014
	$scope.sortType = 'hours'
	$scope.sortReverse = true

	updateHours = () ->
		$scope.warningLimit = 0.5
		$scope.hoursPerMonth = 2.5
		$scope.startOfKitaYear = moment({year: $scope.currentYear, month: 7, day: 1})
		$scope.endOfKitaYear = moment($scope.startOfKitaYear).add(1, 'year')

		now = moment()
		if now.isBefore($scope.startOfKitaYear)
			$scope.monthsOfKitaYear = 0
		else if now.isAfter($scope.endOfKitaYear)
			$scope.monthsOfKitaYear = 12
		else # is between
			$scope.monthsOfKitaYear = moment.duration(now.diff($scope.startOfKitaYear)).months()

		console.log "kitajahr: #{$scope.startOfKitaYear.format()} => #{$scope.endOfKitaYear.format()}"

		allHours = $scope.$meteorCollection () -> share.Hours.find
			date:
				$gte: $scope.startOfKitaYear.toDate()
				$lt:  $scope.endOfKitaYear.toDate()

		$scope.hours = []
		for k, v of _.groupBy(allHours, (h) -> h.family)
			hoursSum = _.sum(v, (h) -> h.hours)
			th = $scope.monthsOfKitaYear * parentCount($meteor.object(share.Families, k)) * $scope.hoursPerMonth
			$scope.hours.push
				familyName: _.first(v)?.familyName
				hours: hoursSum
				targetHours: th
				severity: if hoursSum < th*$scope.warningLimit then 'warning' else 'info'

		console.log $scope.hours

		max = _.max $scope.hours, (h) -> h.hours

		for h in $scope.hours
			#h.hoursPercentage = 100.0 / (max.hours / h.hours)
			h.hoursPercentage = 100.0 / (h.targetHours / h.hours)

		ny = "#{$scope.currentYear+1}".substring 2 
		$scope.currentYearString = "#{$scope.currentYear}/#{ny}"

		$scope.hoursSum = _.sum allHours, (h) -> h.hours

	updateHours()

	$scope.goToPreviousYear = () ->
		$scope.currentYear--
		updateHours()
	$scope.goToNextYear = () ->
		$scope.currentYear++
		updateHours()
]

app.controller 'angCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
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