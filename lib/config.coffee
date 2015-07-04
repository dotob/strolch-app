Accounts.config
	forbidClientAccountCreation: true

share.Families = new Mongo.Collection 'families' 
share.Tags = new Mongo.Collection 'tags' 

share.Families.allow
  insert: (userId, party) ->
    userId and party.owner == userId
  update: (userId, party, fields, modifier) ->
    userId and party.owner == userId
  remove: (userId, party) ->
    userId and party.owner == userId

share.Tags.allow
  insert: (userId, party) ->
    userId and party.owner == userId
  update: (userId, party, fields, modifier) ->
    userId and party.owner == userId
  remove: (userId, party) ->
    userId and party.owner == userId