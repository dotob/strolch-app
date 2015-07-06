families = require './families.json'

fixfon = (fon) ->
	if fon
		n = fon.replace(/\s/g,'')
		console.log "#{fon} => #{n}"
		n
	else
		fon

for family in families
	family.mama.fon = fixfon family.mama.fon
	family.mama.handy = fixfon family.mama.handy
	family.papa.fon = fixfon family.papa.fon
	family.papa.handy = fixfon family.papa.handy

#console.log JSON.stringify families, null, 2