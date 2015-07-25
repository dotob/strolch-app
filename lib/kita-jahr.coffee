# a kita jahr begihns with the 1.8. of a yera and ends with the 30.7. of the next
# a year is therefore named like "2014/15"
# here are some utility functions therefore

share.KiTaJahr = class KiTaJahr
	constructor: (@year) ->

	@current: ->
		now = moment()
		currentYear = now.year()
		if now.month() < 7 # we are in the second half of kita-year
			currentYear--
		currentYear

	startDate: ->
		moment({year: @year, month: 7, day: 1})

	endDate: ->
		moment(@startDate(@year)).add(1, 'year')

	toString: ->
		ny = "#{@year+1}".substring 2 
		"#{@year}/#{ny}"

	# the birth date of a child wich will leave the kita the given year
	birthDateStart: ->
		moment({year: @year-7, month: 9, day: 1})

	birthDateEnd: ->
		moment(@birthDateStart(@year)).add(1, 'year')

