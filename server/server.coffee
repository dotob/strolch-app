Meteor.startup () ->
	# create default user
	stdUser = Meteor.users.findOne({username: "Eltern"})
	if !stdUser
		Accounts.createUser
			username: "Eltern"
			password: "Steppenberg"

	# not used, was for init...
	if false & share.Families.find().count() == 0
		fs = Npm.require 'fs'
		path = Npm.require 'path'
		basepath = path.resolve('.').split('.meteor')[0]
		file = basepath + "server/db.json"
		data_raw = fs.readFileSync file, 'utf8'
		data = JSON.parse data_raw
		for family in data.families
			delete family.id
			share.Families.insert family
	if share.Tags.find().count() == 0
		tags = ['gruppe1', 'gruppe2', 'gruppe3', 'hausmeister', 'garten', 'koop', 'küche', 'vorstand', 'nähen', 'newsletter']
		for tag in tags
			share.Tags.insert {name: tag}
