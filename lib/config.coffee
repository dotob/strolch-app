# do not let user create accounts
Accounts.config
	forbidClientAccountCreation: true

# create collections
share.Families = new Mongo.Collection 'families' 
share.Tags = new Mongo.Collection 'tags' 
share.Hours = new Mongo.Collection 'hours' 
share.Events = new Mongo.Collection 'events' 
share.Settings = new Mongo.Collection 'settings' 

# add created, updated etc fields
share.Families.attachBehaviour 'timestampable'
share.Hours.attachBehaviour 'timestampable'
share.Settings.attachBehaviour 'timestampable'
share.Events.attachBehaviour 'timestampable'

onlyUsers = 
	insert: (userId) ->
		userId?
	update: (userId) ->
		userId?
	remove: (userId) ->
		userId?

onlyAdmin = 
	insert: (userId) ->
		user = Meteor.users.findOne(userId)
		user?.profile?.isAdmin
	update: (userId) ->
		user = Meteor.users.findOne(userId)
		user?.profile?.isAdmin
	remove: (userId) ->
		user = Meteor.users.findOne(userId)
		user?.profile?.isAdmin

# user access config
share.Families.allow onlyUsers
share.Tags.allow onlyUsers
share.Hours.allow onlyUsers
share.Events.allow onlyUsers
share.Settings.allow onlyAdmin

Meteor.users.allow
	remove: (userId) ->
		user = Meteor.users.findOne(userId)
		user?.profile?.isAdmin
