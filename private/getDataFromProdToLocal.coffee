fs = require('fs')
exec = require('child_process').exec

doExportImport = (url, collection, next) ->
	# sample: mongodb://client-d07d18qe:7795a6dc-3e1a-a4fe-ab3f-e632basd1e44d@production-db-c12.meteor.io:27017/example_meteor_com
	[f, user, pass, host, db] = url.match /mongodb:\/\/(\S*?):(\S*?)@(\S*?)\/(\S*)/
	mongoExportCommand = "mongoexport -u #{user} -p #{pass} -h #{host} -d #{db} -c #{collection} --jsonArray"
	console.log mongoExportCommand
	exec mongoExportCommand, (error, stdoutMongoExport, stderr) ->
		console.log "exported: #{stdoutMongoExport}"
		exportFile = "#{collection}.json"
		fs.writeFile exportFile, stdoutMongoExport, (e) ->
			if e
				throw e
			else
				console.log "wrote export file: #{exportFile}"
				mongoImportCommand = "mongoimport --port 3001 -d meteor -c #{collection} --jsonArray --file #{exportFile}"
				exec mongoImportCommand, (error, stdoutMongoImport, stderr) ->
					if error
						throw error
					else
						console.log stdoutMongoImport
						if next
							next()

meteorUrl = process.argv[2]
if meteorUrl
	exec "meteor mongo -U #{meteorUrl}", (error, stdoutMeteorMongo, stderr) ->
		console.log "got url: #{stdoutMeteorMongo}"
		doExportImport stdoutMeteorMongo, 'families', () ->
			doExportImport stdoutMeteorMongo, 'tags', () ->
				doExportImport stdoutMeteorMongo, 'hours'
else
	console.log "not meteor url given!!!!!!!!!!!"