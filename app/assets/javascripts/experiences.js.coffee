class @sourcesService
	@getsourcesHtml = (filters) ->
	# TODO: REDIS CACHE CATEGORIES
		$.ajax("/sources/?#{$.param(filters)}").done (data) ->
			$(document).trigger 'sources:indexHTML', {html: data}
