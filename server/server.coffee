Families = new Mongo.Collection 'families' 
Tags = new Mongo.Collection 'tags' 

Meteor.startup () ->
	if Families.find().count() == 0
		fs = Npm.require 'fs'
		path = Npm.require 'path'
		basepath = path.resolve('.').split('.meteor')[0]
		file = basepath + "server/db.json"
		data_raw = fs.readFileSync file, 'utf8'
		data = JSON.parse data_raw
		for family in data.families
			delete family.id
			Families.insert family
	if Tags.find().count() == 0
		tags = ['gruppe1', 'gruppe2', 'gruppe3', 'hausmeister', 'garten', 'koop', 'küche', 'vorstand', 'nähen', 'newsletter']
		for tag in tags
			Tags.insert {name: tag}
