Meteor.methods
	createNewUser: (newUserName, newUserPassword, newUserAdmin) ->
		Accounts.createUser
			username: newUserName
			password: newUserPassword
			profile:
				isAdmin: newUserAdmin
	setPassword: (id, pw) ->
		Accounts.setPassword id, pw

# fix tags 
share.Tags.after.update (userId, tag) ->
	share.Families.update({'mama.tags._id': tag._id}, {$set: {'mama.tags.$.name': tag.name}}, {multi: true})
	share.Families.update({'papa.tags._id': tag._id}, {$set: {'papa.tags.$.name': tag.name}}, {multi: true})
	share.Families.update({'kinder.0.tags._id': tag._id}, {$set: {'kinder.0.tags.$.name': tag.name}}, {multi: true})
	share.Families.update({'kinder.1.tags._id': tag._id}, {$set: {'kinder.1.tags.$.name': tag.name}}, {multi: true})
	share.Families.update({'kinder.2.tags._id': tag._id}, {$set: {'kinder.2.tags.$.name': tag.name}}, {multi: true})

Meteor.startup () ->
	# deactivate fix for now
	if false
		console.log "###################"
		# fix dates
		for f in share.Families.find().fetch()
			idx = 0
			for k in f.kinder
				if typeof k.dob == 'string'
					console.log k.dob
					dobMoment = moment(k.dob, "DD.MM.YY")
					
					share.Families.update({_id: f._id}, {$set: {"kinder.#{idx}.dob": dobMoment.toDate()}})
				idx++
		console.log "###################"

	if share.Settings.find().count() == 0
		share.Settings.insert
			hoursPerFamilyAndMonth: 5
			kitaYearStartDay: 1
			kitaYearStartMonth: 8
	if share.Tags.find().count() == 0
		share.Tags.insert
			name: 'Gruppe1'
			canEdit: false
			type: 'child'
		share.Tags.insert
			name: 'Gruppe2'
			canEdit: false
			type: 'child'
		share.Tags.insert
			name: 'Gruppe3'
			canEdit: false
			type: 'child'
		share.Tags.insert
			name: 'Vorstand'
			canEdit: false
			type: 'work'
		share.Tags.insert
			name: 'Garten'
			canEdit: false
			type: 'work'
		share.Tags.insert
			name: 'Koop'
			canEdit: false
			type: 'work'
		share.Tags.insert
			name: 'Hausmeister'
			canEdit: false
			type: 'work'
		share.Tags.insert
			name: 'Küche'
			canEdit: false
			type: 'work'
