share.getFamilyName = (family) ->
	if !family.mama?.nachname or !family.papa?.nachname
		family.papa?.nachname || family.mama?.nachname
	else if family.mama.nachname == family.papa.nachname
		family.papa.nachname
	else
		"#{family.mama.nachname} & #{family.papa.nachname}"

share.getFamilyNameCount = (family) ->
	if !family.mama?.nachname or !family.papa?.nachname
		1
	else if family.mama.nachname == family.papa.nachname
		1
	else
		2

share.parentCount = (family) ->
	if !family.mama?.nachname or !family.papa?.nachname
		1
	else
		2
