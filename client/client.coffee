Families = new Mongo.Collection 'families' 
Tags = new Mongo.Collection 'tags' 

app = angular.module 'app', ['angular-meteor', 'ui.router', 'ngTagsInput']

app.config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
	$stateProvider
		.state 'alle',
			url: '/'
			templateUrl: 'client/jade/alle.html'
			controller: 'alleCtrl'
		.state 'neu',
			url: '/neu'
			templateUrl: 'client/jade/eine.html'
			controller: 'neuCtrl'
		.state 'eine',
			url: '/eine/:id'
			templateUrl: 'client/jade/eine.html'
			controller: 'eineCtrl'
			
	$urlRouterProvider.otherwise '/'
	$locationProvider.html5Mode true
]

app.controller 'neuCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.family = {}
	$scope.save = () ->
		$meteor.collection(Families).save $scope.family
		#todo
]

app.controller 'alleCtrl', ['$scope', '$meteor', ($scope, $meteor) ->
	$scope.families = $meteor.collection(Families)
	$scope.deleteFamily = (family) ->
		console.log "delete id: #{family._id}"
		$scope.families.remove family
]

app.controller 'eineCtrl', ['$scope', '$meteor', '$stateParams', ($scope, $meteor, $stateParams) ->
	$scope.family = $meteor.object(Families, $stateParams.id)
	$scope.tags = $meteor.collection(Tags)
	$scope.loadTags = (query) ->
		# filter
		$scope.tags
]