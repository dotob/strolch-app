# do not let user create accounts
Accounts.config
	forbidClientAccountCreation: true

# create collections
share.Families = new Mongo.Collection 'families' 
share.Tags = new Mongo.Collection 'tags' 
share.Hours = new Mongo.Collection 'hours' 

# add created, updated etc fields
share.Families.attachBehaviour 'timestampable'

onlyUsers = 
	insert: (userId) ->
		userId?
	update: (userId) ->
		userId?
	remove: (userId) ->
		userId?

# user access config
share.Families.allow onlyUsers
share.Tags.allow onlyUsers
share.Hours.allow onlyUsers
