# do not let user create accounts
Accounts.config
	forbidClientAccountCreation: true

# create collections
share.Families = new Mongo.Collection 'families' 
share.Tags = new Mongo.Collection 'tags' 

# add created, updated etc fields
share.Families.attachBehaviour 'timestampable'



# user access config
share.Families.allow
	insert: (userId) ->
		userId?
	update: (userId) ->
		userId?
	remove: (userId) ->
		userId?

share.Tags.allow
	insert: (userId) ->
		userId?
	update: (userId) ->
		userId?
	remove: (userId) ->
		userId?