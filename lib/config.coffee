Accounts.config
	forbidClientAccountCreation: true

share.Families = new Mongo.Collection 'families' 
share.Tags = new Mongo.Collection 'tags' 

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