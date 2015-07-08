# do not let user create accounts
Accounts.config
	forbidClientAccountCreation: true

# create collections
share.Families = new Mongo.Collection 'families' 
share.Tags = new Mongo.Collection 'tags' 

# add created, updated etc fields
share.Families.attachBehaviour 'timestampable'

# fix tags 
# TODO learn how to update
# share.Tags.after.update (userId, tag, field) ->
# 	console.log "updated tag"
# 	share.Families.find().forEach (f) ->
# 		if f.mama and f.mama.tags
# 			_.filter(f.mama.tags, (t) -> t._id == tag._id).forEach((t) -> t.name = tag.name;console.log "mama: tagupdate";)
# 		if f.papa and f.papa.tags
# 			_.filter(f.papa.tags, (t) -> t._id == tag._id).forEach((t) -> t.name = tag.name;console.log "papa: tagupdate";)
# 		for k in f.kinder
# 			if k and k.tags
# 				_.filter(k.tags, (t) -> t._id == tag._id).forEach((t) -> t.name = tag.name;console.log "kind: tagupdate";)


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