# meteor accounts config
Accounts.ui.config
  passwordSignupFields: 'USERNAME_ONLY'

# angular
app = angular.module 'app', ['angular-meteor', 'ui.router', 'ngTagsInput']

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
	$scope.family = {}
	$scope.save = () ->
		$meteor.collection(share.Families).save $scope.family
		#todo
]

app.controller 'alleCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.sortType = 'mama.nachname'
	$scope.families = $meteor.collection(share.Families)
	$scope.deleteFamily = (family) ->
		console.log "delete id: #{family._id}"
		$scope.families.remove family
]

app.controller 'tagsCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.tags = $meteor.collection(share.Tags)
	$scope.deleteTag = (tag) ->
		console.log "delete id: #{tag._id}"
		$scope.tags.remove tag
	$scope.addTag = (tagName) ->
		$scope.tags.push {name: tagName}
		$scope.newName = null
]

app.controller 'eineCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(share.Families, $stateParams.id)
	$scope.tags = $meteor.collection(share.Tags)
	$scope.loadTags = (query) ->
		# filter
		$scope.tags
]