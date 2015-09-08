# meteor accounts config
accountsUIBootstrap3.setLanguage 'de'
Accounts.ui.config
	passwordSignupFields: 'USERNAME_ONLY'

# overwrite underscore with lodash
_ = lodash

# angular
angular.module('app', ['angular-meteor', 'ui.router', 'ngTagsInput', 'ui.bootstrap', 'ui.calendar'])

# routes
userResolve = 
	"currentUser": [
		"$meteor", ($meteor) ->
			$meteor.requireUser()
	]

adminResolve = 
	"currentUser": [
		"$meteor", ($meteor) ->
			hasAdmin = Meteor.users.findOne {'profile.isAdmin': true}
			if !hasAdmin
				return true
			else
				return $meteor.requireValidUser (user) ->
					user?.profile?.isAdmin
	]

angular.module('app').config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
	$stateProvider
		.state 'alle',
			url: '/'
			templateUrl: 'client/jade/alle.html'
			controller: 'alleCtrl'
			resolve: userResolve
		.state 'print',
			url: '/print'
			templateUrl: 'client/jade/print.html'
			controller: 'printCtrl'
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
		.state 'calendar',
			url: '/calendar'
			templateUrl: 'client/jade/calendar.html'
			controller: 'calendarCtrl'
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
		.state 'admin',
			url: '/admin'
			templateUrl: 'client/jade/admin.html'
			controller: 'adminCtrl'
			resolve: adminResolve
		.state 'login',
			url: '/login'
			templateUrl: 'client/jade/login.html'
			
	$urlRouterProvider.otherwise '/'
	$locationProvider.html5Mode true
]

angular.module('app').run ['$rootScope', '$state', ($rootScope, $state) ->
	Accounts.onLogin () -> $state.go 'alle'
	accountsUIBootstrap3.logoutCallback = () -> $state.go 'login'
	$rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
		# We can catch the error thrown when the $requireUser promise is rejected
		# and redirect the user back to the main page
		if error == 'AUTH_REQUIRED'
			$state.go 'login'
]

