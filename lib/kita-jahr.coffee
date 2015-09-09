# a kita jahr begins with the e.g. 1.8. of a year and ends with the 30.7. of the next
# a year is therefore named like "2014/15"
# here are some utility functions therefore

share.KiTaJahr = class KiTaJahr
	constructor: (@year, @settings) ->

	@current: (settings) ->
		now = moment()
		currentYear = now.year()
		kitaYearStartMonth = settings.kitaYearStartMonth || 8
		if now.month() < (kitaYearStartMonth-1) # we are in the second half of kita-year
			currentYear--
		currentYear

	startDate: ->
		kitaYearStartDay = @settings.kitaYearStartDay || 1
		kitaYearStartMonth = @settings.kitaYearStartMonth || 8
		moment({year: @year, month: kitaYearStartMonth - 1, day: kitaYearStartDay})

	endDate: ->
		moment(@startDate(@year)).add(1, 'year').subtract(1, 'day')

	toString: ->
		ny = "#{@year+1}".substring 2 # only use 15 of 2015 for example
		"#{@year}/#{ny}"

	# the birth date of a child wich will leave the kita the given year
	birthDateStart: ->
		moment({year: @year-7, month: 9, day: 1})

	birthDateEnd: ->
		moment(@birthDateStart(@year)).add(1, 'year').subtract(1, 'day')

