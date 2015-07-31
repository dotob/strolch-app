fs = require('fs')
exec = require('child_process').exec

doExportImport = (url, collection) ->
	# sample: mongodb://client-d07d18qe:7795a6dc-3e1a-a4fe-ab3f-e632basd1e44d@production-db-c12.meteor.io:27017/example_meteor_com
	[f, user, pass, host, db] = url.match /mongodb:\/\/(\S*?):(\S*?)@(\S*?)\/(\S*)/
	mongoExportCommand = "mongoexport -u #{user} -p #{pass} -h #{host} -d #{db} -c #{collection} --jsonArray"
	console.log "got url: #{stdoutMeteorMongo}"
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

meteorUrl = process.argv[2]
exec "meteor mongo -U #{meteorUrl}", (error, stdoutMeteorMongo, stderr) ->
	doExportImport(stdoutMeteorMongo, 'families')
	doExportImport(stdoutMeteorMongo, 'tags')
	doExportImport(stdoutMeteorMongo, 'hours')