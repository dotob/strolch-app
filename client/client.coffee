# meteor accounts config
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

app.controller 'neuCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.isNew = true
	$scope.family = {}
	$scope.save = () ->
		$scope.$meteorCollection(share.Families).save $scope.family
]

app.controller 'alleCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = false
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.deleteFamily = (family) ->
		if $window.confirm 'Wirklich archivieren?'
			console.log "archive id: #{family._id}"
			family.archived = true
]

app.controller 'archivedCtrl', ['$scope', '$meteor', '$window', ($scope, $meteor, $window) ->
	$scope.sortType = 'mama.nachname'
	$scope.showArchived = true
	$scope.families = $scope.$meteorCollection(share.Families)
	$scope.undeleteFamily = (family) ->
		if $window.confirm 'Wirklich wiederherstellen?'
			console.log "unarchive id: #{family._id}"
			family.archived = false
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
	$scope.tags = $scope.$meteorCollection(share.Tags)
	$scope.loadTags = (query) ->
		# filter
		_.filter $scope.tags, (t) -> t.name.toLowerCase().indexOf(query.toLowerCase()) >= 0
]

app.controller 'addHoursCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	if $scope.family.mama.nachname == $scope.family.papa.nachname
		$scope.familyName = $scope.family.papa.nachname
	else
		$scope.familyName = "#{$scope.family.mama.nachname} && #{$scope.family.papa.nachname}"
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

	updateHours = () ->
		allHours = $scope.$meteorCollection () -> share.Hours.find
			date:
				$gte: new Date($scope.currentYear, 7, 1)
				$lt:  new Date($scope.currentYear+1, 7, 31)

		$scope.hours = []
		for k, v of _.groupBy(allHours, (h) -> h.family)
			$scope.hours.push
				familyName: _.first(v)?.familyName
				hours: _.sum(v, (h) -> h.hours)

		ny = "#{$scope.currentYear+1}".substring 2 
		$scope.currentYearString = "#{$scope.currentYear}/#{ny}"
	
	updateHours()

	$scope.goToPreviousYear = () ->
		$scope.currentYear--
		updateHours()
	$scope.goToNextYear = () ->
		$scope.currentYear++
		updateHours()
]